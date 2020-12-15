## Cloudformation for interview
   * A script that is repeatibly depolyable that creates a non-publicly accessible, containerized application in a VPC behind a load balancer. 
   * A script to run to perform the application deployment from scratch and return the publicly accessible URL with instructions on how to run
   * A script to run to perform the application update that accepts a docker tag with instructions on how to run
     -It should deploy code to the existing environment, and let the user know when it’s ready.

### Export AWS secret keys, else define them in `~/.aws/credentials` -
```sh
export AWS_ACCESS_KEY_ID=********
export AWS_SECRET_ACCESS_KEY=*******************
export AWS_DEFAULT_REGION=us-east-2
```
### Initialize environment - 
```sh
sudo sh create-stacks.sh
```
### Plan (shows execution plan) - 
```sh
sudo sh update-script.sh
```
### Destroy the infra which we build just now - 
```sh
aws cloudformation delete-stack --stack-name name-here
```
