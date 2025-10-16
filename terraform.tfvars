region = "us-east-1"

# network
vpc_cidr = "10.1.0.0/16"
#public_subnet_cidrs  = ["10.1.1.0/24"]
#private_subnet_cidrs = ["10.1.2.0/24"]
#availability_zones   = ["us-east-1a"]



# Key
key_name = "SKYoussefKey"

# EC2 instances: create one instance per entry
ec2_amis = {
  "wordpress-node" = "ami-08d773dde7e3cf7a4"
  "db-image-node"  = "ami-03d64a68bd3196240"
}

ec2_instance_type = "t3.small"




eks_cluster_iam = {
  role_name       = "eks-cluster-role"
  assume_services = ["eks.amazonaws.com"]
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
  tags = {
    Environment = "dev-cluster"
    ManagedBy   = "Terraform-youssef"
  }
}

eks_node_iam = {
  role_name       = "eks-node-role"
  assume_services = ["ec2.amazonaws.com"]
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
  tags = {
    Environment = "dev-node"
    ManagedBy   = "Terraform-youssef"
  }
}
admin_iam_user = "arn:aws:iam::645537741587:user/yousef+sk"
# Allow EKS Control Plane + SSH
eks_nodes_ingress_rules = [
  {
    description = "Allow EKS control plane communication"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with EKS cluster SG or CIDR if known
  },
  {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP
  }
]

# Outbound
instance_egress_rules = [
  {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
eks_access_entries = [
  {
    principal_arn       = "arn:aws:iam::645537741587:user/yousef+sk"
    kubernetes_groups   = ["system:masters"]
    kubernetes_username = "yousef-sk"
    access_policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  }
]
