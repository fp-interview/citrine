#!/bin/bash

# AWS CLI V2 is required
#curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
#sudo installer -pkg AWSCLIV2.pkg -target /

set -ex

NETWORK="citrine-informatics-sample-network2"
SERVICENAME="citrine-informatics-sample-service2"
TAG="${1}"
IMAGE_NAME="sample-service"
REGISTRY="$(cat repositoryUri | cut -d \" -f4)"

# to login to registry
aws --region us-west-2 ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY}

rm -rf ./sample-service
git clone https://github.com/CitrineInformatics/sample-service.git

docker build -t sample-service ./sample-service/ 
docker tag sample-service ${REGISTRY}
docker push ${REGISTRY}

aws cloudformation delete-stack --stack-name ${SERVICENAME}

sleep 40

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