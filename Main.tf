terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "default" 
}

# -----------------------
# NETWORK MODULE
# -----------------------
module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}


# -----------------------
# SECURITY GROUP (EKS Nodes)
# -----------------------
module "eks_nodes_sg" {
  source        = "./modules/securityGroups"
  name          = "eks-nodes-sg"
  description   = "Security group for EKS worker nodes"
  vpc_id        = module.network.vpc_id
  ingress_rules = var.eks_nodes_ingress_rules
  egress_rules  = var.instance_egress_rules
  tags          = merge(var.tags, { "Component" = "EKS-Nodes" })
}




#------------------------
#IAM
#------------------------
# EKS Cluster IAM role
module "eks_cluster_role" {
  source               = "./modules/iam"
  role_name            = var.eks_cluster_iam.role_name
  assume_services      = var.eks_cluster_iam.assume_services
  managed_policy_arns  = var.eks_cluster_iam.managed_policy_arns
  tags                 = lookup(var.eks_cluster_iam, "tags", {})
  create_instance_profile = false
}

# EKS Node IAM role
module "eks_node_role" {
  source                  = "./modules/iam"
  role_name               = var.eks_node_iam.role_name
  assume_services         = var.eks_node_iam.assume_services
  managed_policy_arns     = var.eks_node_iam.managed_policy_arns
  tags                    = lookup(var.eks_node_iam, "tags", {})
  create_instance_profile = true
}


/*
# -----------------------
# EKS Cluster
# -----------------------
module "eks" {
  source = "./modules/eks"

  cluster_name    = "sk-eks-cluster"
  cluster_version = "1.30"

  vpc_id     = module.network.vpc_id
  subnet_ids = concat(values(module.network.public_subnets), values(module.network.private_subnets))

  node_group_name = "sk-node-group"
  instance_types  = ["t3.small"]
  desired_size    = 1
  min_size        = 1
  max_size        = 2

  node_role_arn = module.eks_node_role.role_arn

  tags = var.tags
}

# -----------------------
# Ensure nodes' IAM role is mapped into Kubernetes node groups
# This allows kubelets to authenticate as nodes (system:bootstrappers, system:nodes)
resource "aws_eks_access_entry" "node_role_mapping" {
  depends_on    = [module.eks]
  cluster_name  = module.eks.cluster_name
  principal_arn = module.eks_node_role.role_arn

  type              = "STANDARD"
  kubernetes_groups = ["system:bootstrappers", "system:nodes"]
}

# -----------------------
# Attach required managed policies to the node IAM role (idempotent)
# These attachments are safe to run even if some have been attached already.
resource "aws_iam_role_policy_attachment" "node_worker_policy" { # EKS perms to work in cluster
  depends_on = [module.eks_node_role]
  role       = module.eks_node_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_ecr_readonly" { #Allow acccess to ECR, the images are stored in ECR
  depends_on = [module.eks_node_role]
  role       = module.eks_node_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" { #AWS can communicate and setup networking for the k8s
  depends_on = [module.eks_node_role]
  role       = module.eks_node_role.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}



*/


#Subnets using in for each. Nothing hard coded 2 or 4 Done
#Use Images with a resource in terraform named: data
#Check backend if it works with the lock Done
#auto scale, VMS and launch template as modules 


