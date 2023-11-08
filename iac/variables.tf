# Credentials filename variable.
variable "credentialsFilename" {
  type = string
  default = ".credentials"
}

variable "credentialsSectionName" {
  type = string
  default = "linode"
}

# Settings filename variable.
variable "settingsFilename" {
  type = string
  default = "settings.json"
}

# Private key filename variable.
variable "privateKeyFilename" {
  type = string
  default = ".id_rsa"
}