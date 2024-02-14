# Definition of the firewall rules.
resource "linode_firewall" "default" {
  label           = "sls-firewall"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  # Enables SSH connections.
  inbound {
    label    = "ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = [ "0.0.0.0/0" ]
  }

  # Enables communication in the swarm.
  inbound {
    label    = "swarm"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "2377"
    ipv4     = [ "0.0.0.0/0" ]
  }

  # Enables communication in the swarm.
  inbound {
    label    = "swarm"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "7946"
    ipv4     = [ "0.0.0.0/0" ]
  }

  # Enables communication in the swarm.
  inbound {
    label    = "swarm"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "7946"
    ipv4     = [ "0.0.0.0/0" ]
  }

  # Enables communication in the swarm.
  inbound {
    label    = "swarm"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "4789"
    ipv4     = [ "0.0.0.0/0" ]
  }

  # Enables TCP traffic from the manager node.
  inbound {
    label    = linode_instance.manager.label
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = [ "${linode_instance.manager.ip_address}/32" ]
  }

  # Enables UDP traffic from the manager node.
  inbound {
    label    = linode_instance.manager.label
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "1-65535"
    ipv4     = [ "${linode_instance.manager.ip_address}/32" ]
  }

  # Enables TCP traffic from the worker nodes.
  dynamic "inbound" {
    for_each = { for worker in local.settings.workers : worker.id => worker }

    content {
      label    = inbound.key
      action   = "ACCEPT"
      protocol = "TCP"
      ports    = "1-65535"
      ipv4     = [ "${linode_instance.workers[inbound.key].ip_address}/32" ]
    }
  }

  # Enables UDP traffic from the worker nodes.
  dynamic "inbound" {
    for_each = { for worker in local.settings.workers : worker.id => worker }

    content {
      label    = inbound.key
      action   = "ACCEPT"
      protocol = "UDP"
      ports    = "1-65535"
      ipv4     = [ "${linode_instance.workers[inbound.key].ip_address}/32" ]
    }
  }

  # Enables live video transmit.
  dynamic "inbound" {
    for_each = local.settings.transmitAllowedIps

    content {
      label    = "sls"
      action   = "ACCEPT"
      protocol = "UDP"
      ports    = "1935"
      ipv4     = [ inbound.value ]
    }
  }
}

# Attaches the firewall rules in the manager node.
resource "linode_firewall_device" "manager" {
  entity_id   = linode_instance.manager.id
  firewall_id = linode_firewall.default.id
}

# Attaches the firewall rules in the worker nodes.
resource "linode_firewall_device" "workers" {
  for_each    = { for worker in local.settings.workers : worker.id => worker }
  entity_id   = linode_instance.workers[each.key].id
  firewall_id = linode_firewall.default.id
}