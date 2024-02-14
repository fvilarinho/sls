# Credentials filename definition.
locals {
  credentialsFilename = pathexpand(var.credentialsFilename)
}

# Linode provider credentials.
provider "linode" {
  config_path    = local.credentialsFilename
  config_profile = "linode"
}

# Reads the provisioning attributes.
locals {
  settings = jsondecode(chomp(file(pathexpand(var.settingsFilename))))
}