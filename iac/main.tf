terraform {
  # Required providers definition.
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

# Credentials filename definition.
locals {
  credentialsFilename = pathexpand(var.credentialsFilename)
}