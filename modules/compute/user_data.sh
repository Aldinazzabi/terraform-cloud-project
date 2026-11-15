#!/bin/bash
set -e

# Install Docker
yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker

# Log in to ECR
aws ecr get-login-password --region ${aws_region} | \
  docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com

# Pull and run the app image
docker pull ${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/${ecr_repo_name}:${image_tag}
docker run -d -p 80:80 --restart always \
  ${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/${ecr_repo_name}:${image_tag}