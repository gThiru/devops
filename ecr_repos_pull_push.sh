#!/bin/bash
TARGET_ACCOUNT_REGION="us-east-1"
DESTINATION_ACCOUNT_REGION="us-east-1"
SOURCE_ACCOUNT_BASE_PATH="123.dkr.ecr.$DESTINATION_ACCOUNT_REGION.amazonaws.com"
DESTINATION_ACCOUNT_BASE_PATH="4567.dkr.ecr.$DESTINATION_ACCOUNT_REGION.amazonaws.com"

aws ecr get-login-password --region $TARGET_ACCOUNT_REGION | docker login --username AWS --password-stdin $SOURCE_ACCOUNT_BASE_PATH
REPO_LIST=($(aws ecr describe-repositories --query 'repositories[].repositoryUri' --output text --region $TARGET_ACCOUNT_REGION))
REPO_NAME=($(aws ecr describe-repositories --query 'repositories[].repositoryName' --output text --region $TARGET_ACCOUNT_REGION))


for repo_url in ${!REPO_LIST[@]}; do
        echo "star pulling image ${REPO_LIST[$repo_url]} from Target account"
        aws ecr get-login-password --region $TARGET_ACCOUNT_REGION | docker login --username AWS --password-stdin ${REPO_LIST[$repo_url]}
        docker pull ${REPO_LIST[$repo_url]}:latest


        # Create repo in destination account, remove this line if already created
        #aws ecr create-repository --repository-name ${REPO_NAME[$repo_url]}
        aws ecr get-login-password --region $DESTINATION_ACCOUNT_REGION --profile staging | docker login --username AWS --password-stdin $DESTINATION_ACCOUNT_BASE_PATH/${REPO_NAME[$repo_url]}
        docker tag ${REPO_LIST[$repo_url]}:latest $DESTINATION_ACCOUNT_BASE_PATH/${REPO_NAME[$repo_url]}:latest
        docker push $DESTINATION_ACCOUNT_BASE_PATH/${REPO_NAME[$repo_url]}:latest

        docker rmi $DESTINATION_ACCOUNT_BASE_PATH/${REPO_NAME[$repo_url]}:latest
        docker rmi ${REPO_LIST[$repo_url]}:latest
done

