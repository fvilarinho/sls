# Creates the manager instance of the swarm.
resource "linode_instance" "manager" {
  label           = local.settings.manager.id
  tags            = [ local.settings.manager.tag ]
  type            = local.settings.manager.type
  image           = local.settings.manager.image
  region          = local.settings.manager.region
  private_ip      = true
  root_pass       = random_password.default.result
  authorized_keys = [ chomp(tls_private_key.default.public_key_openssh) ]

  provisioner "remote-exec" {
    # Remote connection attributes.
    connection {
      host        = self.ip_address
      user        = "root"
      password    = random_password.default.result
      private_key = chomp(tls_private_key.default.private_key_openssh)
    }

    # Installs the required software and initialize the swarm.
    inline = [
      "hostnamectl set-hostname ${self.label}",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update",
      "apt -y upgrade",
      "apt -y install bash ca-certificates curl wget htop dnsutils net-tools vim",
      "curl https://get.docker.com | sh -",
      "systemctl enable docker",
      "systemctl start docker",
      "docker swarm init --advertise-addr=${self.ip_address}"
    ]
  }

  depends_on = [ random_password.default ]
}

# Gets the swarm token.
data "external" swarmToken {
  program = [
    "./getSwarmToken.sh",
    linode_instance.manager.ip_address
  ]

  depends_on = [ linode_instance.manager ]
}

# Creates a worker instance of the swarm.
resource "linode_instance" "workers" {
  for_each        = { for worker in local.settings.workers : worker.id => worker }
  label           = each.key
  tags            = [ each.value.tag ]
  type            = each.value.type
  image           = each.value.image
  region          = each.value.region
  private_ip      = true
  authorized_keys = [ chomp(tls_private_key.default.public_key_openssh) ]

  # Remote connection attributes.
  provisioner "remote-exec" {
    connection {
      host        = self.ip_address
      user        = "root"
      password    = random_password.default.result
      private_key = chomp(tls_private_key.default.private_key_openssh)
    }

    # Installs the required software and join the instance in the swarm.
    inline = [
      "hostnamectl set-hostname ${self.label}",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update",
      "apt -y upgrade",
      "apt -y install bash ca-certificates curl wget htop dnsutils net-tools vim",
      "curl https://get.docker.com | sh -",
      "systemctl enable docker",
      "systemctl start docker",
      "docker swarm join --token ${data.external.swarmToken.result.token} ${linode_instance.manager.ip_address}:2377"
    ]
  }

  depends_on = [ data.external.swarmToken ]
}

# Applies the stack in the swarm.
resource "null_resource" "applyStack" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    environment = {
      MANAGER_NODE = linode_instance.manager.ip_address
    }

    quiet = true
    command = "./applyStack.sh"
  }

  depends_on = [ linode_instance.workers ]
}

# Removes inactive nodes from the swarm.
resource "null_resource" "cleanSwarm" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "remote-exec" {
    # Remote connection attributes.
    connection {
      host        = linode_instance.manager.ip_address
      user        = "root"
      password    = random_password.default.result
      private_key = chomp(tls_private_key.default.private_key_openssh)
    }

    inline = [
      "NODES=$(docker node ls | grep Down | awk {'print $1'})",
      "if [ -n \"$NODES\" ]; then docker node rm -f $NODES; fi"
    ]
  }

  depends_on = [ linode_instance.workers ]
}