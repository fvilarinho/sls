# Private key filename definition.
locals {
  privateKeyFilename = pathexpand(var.privateKeyFilename)
}

# Create the SSH private key.
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Save the SSH private key file.
resource "local_sensitive_file" "privateKey" {
  filename        = local.privateKeyFilename
  content         = tls_private_key.default.private_key_openssh
  file_permission = "600"
  depends_on      = [ tls_private_key.default ]
}