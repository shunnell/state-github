include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "k8s" {
  path = "${get_repo_root()}/_envcommon/platform/eks/k8s.hcl"
}

include "runner_fleet" {
  path = "${get_path_to_repo_root()}/_envcommon/platform/gitlab/team_runner_fleet.hcl"
}

inputs = {
  runner_fleet_name_suffix = "testing"
  concurrency_jobs_per_pod = 1 # IVA's jobs are quite expensive in memory and storage, so limit how many runner pods exist.
  concurrency_pods         = 4 # Testing runners have reduced concurrency so as not to take up unnecessary resources.
  builder_memory           = "3Gi"
  deployer_roles = [
    "arn:aws:iam::730335386746:role/sandbox/Pipeline-Programmatic-Role",
    "arn:aws:iam::730335386746:role/sandbox-iva-iac-role"
  ]
  read_only_root = true
}
