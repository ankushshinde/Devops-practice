store your tfstate file in remote location ---> s3

terraform state file (terraform.tfstate) file
When you enter terraform apply command in a directory, terraform saves the state of the resources changed in a file called the state file that is named terraform.tfstate in your working directory.

This file refers how terraform knows what to change, or destroy when you use terraform apply or destroy after creating a stack of resources.

The state stores by default in a local file named "terraform.tfstate", but it can also be stored remotely, which works better in a team environment.

Here, we will store our state file remotely in S3. so that other team members will work with the resources to create can change and destroy the terraform stack. This also allows to version control the state file so that chances of losing the state file by mistake is minimized.

Remote state is a feature of backends

A "backend" in Terraform determines how state is loaded and how an operation such as apply is executed. This abstraction enables non-local file state storage, remote execution, etc.

Keep in mind, state can be stored in other backends like consul, artifactory, azure storage etc. We will work with Amazon s3 in this lesson to store the remote file.

Here are some of the benefits of backends:

Working in a team: Backends can store their state remotely and protect that state with locks to prevent corruption. Some backends such as Terraform Enterprise even automatically store a history of all state revisions.

Keeping sensitive information off disk: State is retrieved from backends on demand and only stored in memory. If you're using a backend such as Amazon S3, the only location the state ever is persisted is in S3.

Remote operations: For larger infrastructures or certain changes, terraform apply can take a long, long time. Some backends support remote operations which enable the operation to execute remotely. You can then turn off your computer and your operation will still complete. Paired with remote state storage and locking above, this also helps in team environments.
Steps
Demo: what happens without the remote state.

Create a s3backend.tf file ( file can be with any name ) in your working directory. Add this as the content

terraform {
  backend "s3" {
    bucket = "my-terraform-status"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
Replace the bucket name, region and path with your desired names. Make sure the S3 bucket exists. 
NOTE: the AWS Credentials need to have access to S3 to work with S3 as the backend to store state file.

Add other main.tf (file can be with any name) file with resources and provider settings.
provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "us-east-1"
}

resource "aws_instance" "" {
  ami           = ""
  instance_type = "t2.micro"
}
Initialize the working directory with below command.
here, you man get the error [] if access_key and secret_key is not configured. in this case, we can provide it with below command 

terraform init -backend-config="access_key=<your-access-key>" -backend-config="secret_key=<your-secret-key>"

otherwise simply execute below command.

terraform init

4 ) Apply the changes with this command

terraform apply
In your working dirctory, you should't see any terraform.tfstate file. so let's go and check our s3 bucket, the state file should be there.

Now, Let's destroy our resources with this command

terraform destroy

Reference
https://www.terraform.io/docs/state/index.html

https://www.terraform.io/docs/state/remote.html

https://www.terraform.io/docs/backends/index.html