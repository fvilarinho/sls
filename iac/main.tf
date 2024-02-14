# Terraform definition.
terraform {
  # State management definition.
  backend "s3" {
    bucket                      = "fvilarin-devops"
    key                         = "sls.tfstate"
    region                      = "us-east-1"
    endpoint                    = "us-east-1.linodeobjects.com"
    skip_credentials_validation = true
  }

  # Required providers definition.
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}