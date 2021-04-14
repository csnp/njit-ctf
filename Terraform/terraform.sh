#!/bin/bash
set -e

export TF_IN_AUTOMATION=1

# terraform.sh dev ecs apply
environment=$1
module=$2
action=$3

# PWD + module name + environment
config_dir="$PWD/config/${environment}/${module}"
module_dir="$PWD/modules/${module}"
out_plan="${module_dir}/terraform.tfplan"

cd "${config_dir}"

# You can set predefined flags to each command via env
export TF_CLI_ARGS_init="-backend-config=${config_dir}/backend.tfvars -input=false -reconfigure ${module_dir}"
export TF_CLI_ARGS_plan="-var-file=${config_dir}/terraform.tfvars -out=${out_plan} -input=false ${module_dir}"
export TF_CLI_ARGS_destroy="-var-file=${config_dir}/terraform.tfvars ${module_dir}"
export TF_CLI_ARGS_apply="-input=false ${out_plan}"

# init
terraform init 

echo "Formatting files"
terraform fmt > /dev/null

if [[ "$action" == "apply" ]]; then
  terraform plan
  echo
  echo "*********************************************************"
  echo "Are you sure you want to apply the above plan? type (y/n)"
  echo "*********************************************************"

  # Read input, timeout after 240s
  read -r -t 300
  if [ "$REPLY" != "y" ]; then
    echo "quitting"
    exit 1
  fi
fi

# Get  the new DB password, set as $DB_PASSWORD; this will be read by TF on create to change the DB password so its not stored in state
if [[ "$action" == "apply" ]]; then
  if [[ "$module" == "database" ]]; then
    # todo: make some more elegant solution
    stty -echo
    read -s -p "Input new database password: " DB_PASSWORD; echo
    stty echo 
    export DB_PASSWORD
  fi
fi

terraform "$action"