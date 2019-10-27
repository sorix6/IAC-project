aws cloudformation update-stack \
--stack-name=$1  \
--parameters=file://$2 \
--template-body=file://$3 \
--region=us-west-2 \
--capabilities CAPABILITY_NAMED_IAM