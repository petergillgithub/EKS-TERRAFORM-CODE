comman_tags = {
    "Env" = "Development"
    "Company" = "Peter Tech"
}

vpc_cidr_block = "10.1.0.0/16"
public_subnet = ["10.1.0.0/19","10.1.32.0/19"]
private_subnet = ["10.1.64.0/18","10.1.128.0/17"]
nodegroup_instance_type = "t2.medium"
nodegroup_desired_size = 2
nodegroup_max_size = 3
nodegroup_min_size = 2
