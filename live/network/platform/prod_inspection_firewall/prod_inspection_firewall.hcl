locals {
  # Load common variables
  account_vars  = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  platform_vars = read_terragrunt_config(find_in_parent_folders("team.hcl"))

  # Extract commonly used variables
  common_identifier = "${local.account_vars.locals.account}-${local.platform_vars.locals.team}-prod-inspection"
  vpc_name          = "${local.common_identifier}-vpc"
  bespin_cidr_block = local.account_vars.locals.bespin_cidr_block
}