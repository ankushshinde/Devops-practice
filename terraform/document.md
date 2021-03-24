# The tfstate file store in a remote location ---> aws-s3

### The terraform state file is "terraform.tfstate".

When you execute _terraform apply_ command, terraform saves the state of the resources changed in a file called the state file that is named terraform.tfstate in your working directory.

This file refers how the terraform knows what to change, or destroy when you use _terraform apply_ or _terraform destroy_ after creating a stack of resources.

The state file store by default in a current working directory with file named **terraform.tfstate**. But it can also be stored remotely which works better in a team environment to be shared.

Here, we will store our state file remotely in AWS-S3 bucket. So that other team members will work with the resources to create, change and destroy the terraform stack. This also do versioning to control the state file, so that chances of losing the state file by mistake is minimized.

Remote state is a feature of backends.

A **"backend"** in Terraform determines how state is loaded and how an operation such as _apply_ is executed. This abstraction enables non-local file state storage, remote execution, etc.

Also, state can be stored in other backends like consul, artifactory, azure storage etc. We will work with Amazon s3 in this lesson to store the remote file.

#### Here are some of the benefits of backends:

- **Working in a team:**  Backends can store their state remotely and protect that state with locks to prevent corruption. Some backends such as Terraform Enterprise even automatically store a history of all state revisions.

- **Keeping sensitive information off disk:** State is retrieved from backends on demand and only stored in memory. If you're using a backend such as Amazon S3, the only location the state ever is persisted is in S3.

- **Remote operations:** For larger infrastructures or certain changes, terraform apply can take a long, long time. Some backends support remote operations which enable the operation to execute remotely. You can then turn off your computer and your operation will still complete. Paired with remote state storage and locking above, this also helps in team environments.

### Steps:
##### 1) Create a s3backend.tf file ( file can be with any name ) in your working directory. Add this as the content

```javascript
terraform {
  backend "s3" {
    bucket = "my-terraform-status"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
```
Replace the bucket name, region and path with your desired names. Make sure the S3 bucket exists. 

NOTE: the AWS Credentials need to have access to S3 to work with S3 as the backend to store state file.

##### 2) Add other main.tf (file can be with any name) file with resources and provider settings.

```javascript
provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami           = "ami-013f17f36f8b"
  instance_type = "t2.micro"
}
```

##### 3) Initialize the working directory with below command.

here, you may get this [Error](https://github.com/ankushshinde/Devops-practice/blob/master/terraform/errors/configuring-S3-Backend.md) if access_key and secret_key is not configured. So in this case, we can provide it with below command 

```javascript
terraform init -backend-config="access_key=<your-access-key>" -backend-config="secret_key=<your-secret-key>"
```
otherwise simply execute below command.

```javascript
terraform init
```
##### 4 ) Apply the changes with this command
```javascript
terraform apply
```
In your working dirctory, you should't see any terraform.tfstate file. so let's go and check our s3 bucket, the state file should be there.

Now, Let's destroy our resources with this command
```javascript
terraform destroy
```
Reference:

https://www.terraform.io/docs/state/index.html

https://www.terraform.io/docs/state/remote.html

https://www.terraform.io/docs/backends/index.html
