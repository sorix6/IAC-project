# Deploying infrastructure as code

This project contains CloudFormation configuration and scripts that allow for the deployment of an Apache Web Server application.  

The built infrastructure should contain:

- 1 VPC
- 2 Public subnets
- 2 Private subnets
- 4 servers, 2 located in each of your private subnets
- An auto-scaling group

## Useful commands

1. The two scripts: ```create.sh``` and ```update.sh``` can be run to either create or update the stack, as follows:

```shell
# Create a new stack
# Expects 3 parameters in the following order:
# 1. Name of stack
# 2. Path of the JSON file containing parameters
# 3. The YML file containing the stack definition
./create.sh IACProject parameters.json high-availability-app.yml

# Update a new stack
# Expects the same 3 parameters as the create command
./update.sh IACProject parameters.json high-availability-app.yml
```

**!** If you're not letting CloudFormation name your IAM resources and you run a create or update script without ```--capabilities CAPABILITY_NAMED_IAM``` an InsufficientCapabilitiesException error is thrown.

2. To delete an existent CLoudFormation stack:

```shell
aws cloudformation delete-stack --stack-name IACProject
```

3. To SSH to an Ubuntu EC2 instance:

```shell
ssh -i keypair.pem ubuntu@public-dns-of-ec2-instance
```

**It is important to mention that in order for this command to work, you need to make sure that your key pair on your local machine has the appropriate permissions ```chmod 600 keypair.pem``` (keypair needs to be read-only)**

**If your EC2 instance is not Ubuntu, the user ```ubuntu``` should be replaced by the appropriate usernale for each operating system.**

4. When building your stack, to retrive the image ID for a specific AMI, use the ```aws ec2 describe-image``` command with the appropriate filters.

```shell
aws ec2 describe-images --owners 099720109477 --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-????????' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text
```

SSH needs to be made available for your instance in the configuration as follows:

- Adding the keypair to the Launch Configuration
- Allowing the port 22 in the ingress connections on the security group of your instance

This configuration should not be kept in production environments.

The logs of the build for the instance can be found at ```less /var/log/cloud-init-output.log```.
