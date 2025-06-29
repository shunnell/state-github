include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}/../modules//network/app_load_balancer"
}

dependency "public_subnets" {
  config_path = "${get_path_to_repo_root()}/network/platform/non_prod_ingress_vpc/vpc/public_subnets"
  mock_outputs = {
    subnets = [
      { subnet_id = "subnet-11111111", az = "us-east-1a" },
      { subnet_id = "subnet-22222222", az = "us-east-1b" },
      { subnet_id = "subnet-33333333", az = "us-east-1c" }
    ]
  }
}

dependency "vpc" {
  config_path = "${get_path_to_repo_root()}/network/platform/non_prod_ingress_vpc/vpc"
  mock_outputs = {
    vpc_id = "vpc-abcdef1234567890"
  }
}

inputs = {
  name_prefix = "non-prod-multitenant"
  vpc_id      = dependency.vpc.outputs.vpc_id
  # use public subnets for the ALB
  subnets = [
    for subnet_info in dependency.public_subnets.outputs.subnets :
    subnet_info.subnet_id
  ]
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd-efgh" # TODO: Create story, need to swap in real ARN
  allowed_ingress_cidrs = [
    "204.51.100.33/32" # Replace with as narrow of a CIDR block as possible
  ]


  tenants = {
    app1 = {
      host_header = "app1.us-east-1.cloud-city.ca.state.sbu"
      priority    = 10
      port        = 80
    }
    app2 = {
      host_header = "app2.us-east-1.cloud-city.ca.state.sbu"
      priority    = 20
      port        = 80
    }
    app3 = {
      host_header = "app3.us-east-1.cloud-city.ca.state.sbu"
      priority    = 30
      port        = 80
    }
  }

  tags = {
    Environment = "non-prod"
    Project     = "MultiTenantApp"
  }

}
