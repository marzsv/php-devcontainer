#!/bin/bash

# Set the AWS profile and endpoint URL from envvars
AWS_PROFILE=${AWS_PROFILE:-default}
AWS_ENDPOINT_URL=${AWS_ENDPOINT_URL:-}

# Construct the AWS command with the profile and endpoint URL options
AWS_COMMAND="aws --profile ${AWS_PROFILE}"
if [ -n "${AWS_ENDPOINT_URL}" ]; then
  AWS_COMMAND="${AWS_COMMAND} --endpoint-url ${AWS_ENDPOINT_URL}"
fi

# Append the remaining arguments to the AWS command
AWS_COMMAND="${AWS_COMMAND} $@"

# Execute the AWS command
eval "${AWS_COMMAND}"
