#!/bin/bash

set -ex

NETWORK="citrine-informatics-sample-network"
SERVICENAME="citrine-informatics-sample-service"
TAG="${1}"
IMAGE_NAME="sample-service"

aws cloudformation create-stack \
  --stack-name ${NETWORK} \
  --template-body file://network.yaml \
  --capabilities CAPABILITY_IAM

# Copy URI ID to file
aws ecr create-repository --repository-name sample-service --region us-west-2 | grep repositoryUri |  tee repositoryUri
REGISTRY="$(cat repositoryUri | cut -d \" -f4)"

# NOTE: AWS CLI V2 is required
#curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
#sudo installer -pkg AWSCLIV2.pkg -target /

# Create docker image from github

aws --region us-west-2 ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY}

sudo rm -rf ./sample-service
git clone https://github.com/CitrineInformatics/sample-service.git

docker build -t sample-service ./sample-service/ 
docker tag sample-service ${REGISTRY}
docker push ${REGISTRY}


aws cloudformation create-stack \
  --stack-name ${SERVICENAME} \
  --template-body file://service.yaml \
  --parameters \
      ParameterKey=StackName,ParameterValue=${NETWORK} \
      ParameterKey=ServiceName,ParameterValue=${IMAGE_NAME} \
      ParameterKey=ImageUrl,ParameterValue=${REGISTRY}:latest \
      ParameterKey=ContainerPort,ParameterValue=5000 \
      ParameterKey=HealthCheckPath,ParameterValue=/healthcheck \
      ParameterKey=HealthCheckIntervalSeconds,ParameterValue=90

echo "https://"$(aws elbv2 describe-load-balancers | grep DNSName | cut -d \" -f4)":5000/"
# URI 465171478242.dkr.ecr.us-west-2.amazonaws.com/sample-service
