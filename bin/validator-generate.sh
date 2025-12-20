#!/usr/bin/env bash
root_dir=$(cd "$(dirname "$0")"; cd ..; pwd)

# grep all request validator
sh $root_dir/bin/validator_grep.sh

pb_dir=$root_dir/pb

validatorGenExec=$(which "validator_gen")
if [ -z $validatorGenExec ]; then
  # request validator code
  go install github.com/daheige/validator_gen@latest

  validatorGenExec=$(which "validator_gen")
fi

$validatorGenExec -pb_dir=$pb_dir -validator_log_dir=$root_dir

echo "generate validator request interceptor success"

exit 0
