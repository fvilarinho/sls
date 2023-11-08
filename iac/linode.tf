# Linode provider credentials.
provider "linode" {
  config_path    = local.credentialsFilename
  config_profile = var.credentialsSectionName
}

# Read provisioning attributes.
locals {
  settings = jsondecode(chomp(file(pathexpand(var.settingsFilename))))
}