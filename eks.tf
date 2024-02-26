resource "aws_eks_cluster" "eks_cluster" {
  name     = "Demo_EKS_Cluster"
  version  = "1.28"
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids              = flatten([aws_subnet.publicsubnet[*].id, aws_subnet.privatesubnet[*].id, ])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policyattachement]

  tags = {
    "Name" = "EKS-Cluster"
  }

}




resource "aws_iam_role" "cluster_role" {
  name               = "eks_cluster_role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
  tags = {
    "Name" = "Eks-Cluster-Role"
  }

}

resource "aws_iam_role_policy_attachment" "eks_cluster_policyattachement" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name

}

resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks_node_group"
  node_role_arn   = aws_iam_role.worker_iam_role.arn
  subnet_ids      = aws_subnet.privatesubnet[*].id

  scaling_config {
    max_size     = var.nodegroup_max_size
    min_size     = var.nodegroup_min_size
    desired_size = var.nodegroup_desired_size
  }
  update_config {
    max_unavailable = 1
  }

  ami_type       = "AL2_x86_64"
  disk_size      = 20
  capacity_type  = "ON_DEMAND"
  instance_types = [var.nodegroup_instance_type]


  depends_on = [aws_iam_role_policy_attachment.worker_policy_attachement]

  tags = {
    "Name" = "Worker-Node-Group"
  }
}


resource "aws_iam_role" "worker_iam_role" {
  name               = "worker_iam_role"
  assume_role_policy = data.aws_iam_policy_document.worker_assume_role.json
}

resource "aws_iam_role_policy_attachment" "worker_policy_attachement" {
  for_each   = var.worker_policies
  role       = aws_iam_role.worker_iam_role.name
  policy_arn = each.value

}

