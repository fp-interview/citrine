
## Terraform for interview
   * Create AWS account
   * Create user account with Programmatic access and Administrator role access
   * Write terraform to create VPC/Security Groups/ALB/Amzn2 Instance


### Export AWS secret keys, else define them in `aws-provider.tf` -
```sh
export AWS_ACCESS_KEY_ID=********
export AWS_SECRET_ACCESS_KEY=*******************
export AWS_DEFAULT_REGION=us-west-2
```
### Initialize terraform -
```sh
terraform init
```
### Plan (shows execution plan) -
```sh
terraform plan -out terraform-plan-key
```
### Apply (Creates the defined infrastructure) -
```sh
tterraform apply terraform-plan-key
```
### Output -
You will get the ALB DNS name in the output. Open the URL in your browser to see the webpage.
```sh
Apply complete! Resources: 31 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

dns_name = inkstom-alb-1400988643.us-east-2.elb.amazonaws.com
```
### Destroy the infra which we build just now -
```sh
terraform destroy
```
