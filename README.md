# README #

### projects
branch - shared_image
1. API https://github.com/simply-video/simply-video-api
2. provision_portal API https://github.com/simply-video/simply-video-provision_portal
3. SAAS Fromtend https://github.com/simply-video/simply-video-saas-frontend
4. Provision portal https://github.com/simply-video/simply-video-provisioning-portal

#### Credentials
set AWS_PROFILE or AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY enviroment veriables

#### Create state s3 Bucket
- navidate to "state_s3_bucket"
- set required bucket and region 
- run commnad "terraform init"
- run command "terraform apply"

#### Generate bastion ssh key
ssh-keygen -t rsa  -b 2048 -f private_key.ppk
private_key.ppk.pub save to auth_bastion_ssh_key variable


#### Create a domain and ssh certificate_arn
- conficure domain in aws route 53
- create a new aws certificate
- add parameter value lb_listener_https_certificate_arn


#### Allow access to ECR from client aws
https://aws.amazon.com/premiumsupport/knowledge-center/secondary-account-access-ecr/
   {
      "Sid": "AllowPull_accout_1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<aws_clinet_id>:root"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    },



#### database seed

1. create database 'svstgndb' and 'sv_chat_db'


2. login to fargate
2.1. login to bastion
2.2. aws ecs update-service --cluster <cluster_name> --service <service_name> --enable-execute-command 
aws ecs update-service --cluster test-simplyvideo-ecs-cluster --service test-simplyvideo-api-service --enable-execute-command
aws ecs update-service --cluster test-simplyvideo-ecs-cluster --service test-simplyvideo-frontend-service --enable-execute-command

2.3. stop current task and wait a new one (previous command appling only for a new task)
2.4. aws ecs execute-command  \
    --region <region> \
    --cluster <cluster-name> \
    --task <task id> \
    --container api \
    --command "/bin/bash" \
    --interactive

    aws ecs execute-command  \
    --region eu-central-1 \
    --cluster test-simplyvideo-ecs-cluster \
    --task b82be47b9e4a4509ae85f978e40c8d58 \
    --container frontend \
    --command "sh" \
    --interactive

2.5. run php artisan migrate:fresh --seed
2.6. exit
2.7. aws ecs update-service --cluster <cluster_name> --service <service_name> --disenable-execute-command
aws ecs update-service --cluster test-simplyvideo-ecs-cluster --service test-simplyvideo-api-service --disenable-execute-command
2.8. stop current task


### frontend
need to updated base api url manually.