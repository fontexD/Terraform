!!!! everything in # is a comment anything else is a cli-command to execute, this script it based on the eu-north-1 datecenter for aws

1. #First download aws-cli https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html, then terraform https://learn.hashicorp.com/tutorials/terraform/install-cli
2. aws configure #enter your aws-secret and access key, can be obtianed/Created in the ec2-console go to your account click security > users > <username> > security credentials, create access key, store your credentials a secret place, add them into the main.tf file on the top
3. aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem  #create ssh key
4. terraform init #init the aws plugin for terraform
5. terraform plan #verify everything is ok 
6. terraform apply # start building the vm
7. afterwards you will get an external ip / dns name whch you can access as http site since it installs an apache server, and ssh to by this commond on lin 8.
8. ssh -i MyKeyPair.pem ubuntu@<your-external-ip> # if you get the error that the file is not secure run this "chmod 600 MyKeyPair.pem"