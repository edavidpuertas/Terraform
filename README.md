# Config credencial in AWS cli:


aws configure
AWS Acces Key Id[None]:
AWS Secret Acces key [None]:
Default region name[None]: us-east-1
Default output format[None]

# Validate aws  account

aws sts get-caller-identity

List  configuration

aws configure list

# Save a plan ,running it and detroy it
terraform apply -out s3.plan
terraform apply "s3.plan"
terraform destroy

# Define env variable in the commnad line

export TF_VAR_virginia_cidr="10.10.0.0/16"

terraform plan -var ohio_cidr="10.20.0.0/16"

## Erase env variable
unset TF_VAR_virginia_cidr

## Nomenclature variable file
terraform.tfvars ||  *.auto.tfvar (example: bucket.auto.tfvars)
terraform.tfvars.json ||  *.auto.tfvar.json (example: Nets.auto.tfvars.json)
commnad line: tarraform plan --var-file anhoterName.tfvars

## precedence priority (highest more priority)
1 - env variable (export TF_VAR_ejemplo="valor")
2 - terraform.tfvars
3 - *.auto.tfvars(alfabetic sort)
4 - -var || -var-file(commnad line)

## Variable type:
string -  example "10.10.0.0/16"
number -  example 1
bool -    true/false
any  -    any type

### List ( same type of elements and it allow repeated elements )
example:
```bash
variable "list_cidrs" {
    default = ["10.10.0.0/16", "10.20.0.0/16"]
    #           Posicion 0       Posicion 1
    type  = list(string)
}

resource "aws_vpc" "vpc_virginia" {
    cidr_bloc = var.lista_cidrs[0]
    tags = {
        Name = "VPC_VIRGINIA"
        name = "prueba"
        env = "Dev"
    }
}

```
### Map
example:
```bash
variable "map_cidrs" {
    default = {
        "virginia" = "10.10.0.0/16"
        "ohio" = "10.20.0.0/16"
    }
    type = map(string)
}
resource "aws_vpc" "vpc_ohio" {
    cidr_bloc = var.lista_cidrs["ohio"]
    tags = {
        Name = "VPC_OHIO"
        name = "prueba"
        env = "Dev"
    }
    provider = aws.ohio
}

```
### Set (it restrict repetead elements, we can't it acces  individual elements)
example:
```bash
variable "set_cidrs" {
    default = ["10.10.0.0/16", "10.20.0.0/16"]
    type = set(string)
}

rsource "aws_vpc" "vpc" {
    for_each = var.set_cidrs
    cidr_block = each.value
    tags = {
        Name = "VPC_TEST"
        name = "prueba"
        env = "Dev"
    }
}

```
### Object ( muliple type of variable)
Example:
```bash
variable "virginia" {
    type = object ({
        nombre = string
        cantidad = number
        cidrs = list(string)
        disponible = bool
        env = string
        owner = string
    })

    default = {
      cantidad  = 1
      cidrs = ["10.10.0.0/16"]
      disponible = true
      env = "Dev"
      nombre = "Virgina"
      owner = " David"
    }
}

resource "aws_vpc" "vpc_virginia"{
    cidr_block = var.virginia.cidrs[0]
    tags = {
        Name = var.virginia.nombre
        name = var.virginia.nombre
        env = var.virginia.env
    }
}

```
### Tuple 
example:
```bash
variable "ohio" {
    type = tuple([string,string,number,bool,string])
    default = ["ohio", "10.20.0.0/16", 1, false, "Dev"]
}

resource "aws_vpc" "vpc_ohio" {
    cidr_block = var.ohio[1]
    tags = {
        Name = var.ohio[0]
        name = var.ohio[0]
        env = var.ohio[4]
    }
    provider = aws.ohio
}

```

## conversion type
automatic conversion
String --> number and viceversa
String --> bool   and viceversa

### - Output ( show atribute reference)

output "linux_public_ip"{
    value = aws_instance.linux.public_ip
    description = "It show the public ip asigned to the instance"
}

## Auto-Approve
 terraform apply --auto-approve=true
 terraform destroy --auto-approve=true

## Targeting
  terraform apply -target aws_subnet.public_subnet

  Revert with the commnad:
  terraform apply --auto-pprove=true

## Terraform .tfstate
only safe in AWS S3(encrypted and with concurrency control like dynamo db) or Terraform Cloud

## Commnads
terraform validate
terraform fmt
terraform show -json
terraform providers
terraform outputterraform plan
terraform refresh (update .tfstate)
terraform graph | dot -Tsvg > graph.svg (show resource realtionship)
terraform state list
terraform state show  | resource.nameresource
terraform state mv (move resource in .tfstate, example action:change name resource)
terraform state rm (stop follow resources)

## Provisioners
example:
terraform destroy --target=aws_instance.public_instance --auto-approved=true

terraform apply --replace=aws_instance.public_instance

## Taint
mark resources to be destroyed and recreated

terraform state list
terraform taint aws_instance.public_instance
terraform untaint aws_instance.public_instance

## Login
export TF_LOG=TRACE #(type info,warning,error,debug,trace)
export TF_LOG_PATH=logs.txt
unset  TF_LOG=TRACE
unset TF_LOG_PATH

## Import resources
1- terraform state list
2 - manual errase aws  intance 
3 - terraform state rm aws_instance.public_instance
4 - comment all instance code
5 - create instance using AWS GUI
6 - ADD in ec2.tf:

resource "aws_instance" "mywebserver" {

}

7 - terraform import aws_instance.mywebserver id
8 -terraform state list
9 - terraform state show nameResource
10 - copy and paste in ec2.tf, errase and formating data of the resource

## Workspace (terraform.tftstate.d)
terraform workspace list || terraform workspace show
terraform workspace new nameWorkSpace
terraform workspace dev
terraform workspace select nameWorkspace
terraform workspace delete nameWorkspace

destroy only instance



## For each ( only use vith variables set an maps )
terraform destroy --target=aws_instance.public_instance --auto-approve=true

## Terraform Functions
terraform console
~~~
split()
lower()
upper()
title(var.cadena)
substr(var.cadena,0,7)
join("-",var.palabras)
length(var.palabras)
index(var.palabras,"como")
element(var.palabras,2)
contains(var.palabras,"cuaolquiera) /true o false
~~~

Maps:
~~~
key(var.entornos)
values(var,entornos)
lookup(var.entornos,"10.10.0.0/16)
lookup(var.entornos,"10.10.0.0/16,"no existe")
~~~

Terraform tfstate backend

#Start to use tfstate backend and move our tfstate to aws bucket s3
terraform init
yes

#delete tefstate local

#Finish remote work
1 -terraform state pull > terraform.tfstate #downdload the tfstate from our s3 bucket to local
2 - Delete backend file or comment it
3 - terraform init
4 - terraform init -migrate-state




