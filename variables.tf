variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"


}


variable "public_subnet" {
  type    = list(string)
  default = ["10.0.0.0/19", "10.0.32.0/19"]


}

variable "private_subnet" {
  type    = list(string)
  default = ["10.0.64.0/18", "10.0.128.0/17"]

}

variable "comman_tags" {
  type = map(string)
  default = {
    "ENV"  = "Dev"
    "Team" = "Terraform"
  }

}

variable "worker_policies" {
  type = set(string)
  default = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]

}

variable "nodegroup_instance_type" {
  type    = string
  default = "t2.medium"

}

variable "nodegroup_desired_size" {
  type    = number
  default = 1

}

variable "nodegroup_min_size" {
  type    = number
  default = 1

}

variable "nodegroup_max_size" {
  type    = number
  default = 3

}