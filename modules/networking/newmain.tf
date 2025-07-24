# resource "oci_identity_compartment" "demo-oke-private" {
#   name           = var.child_compartment_name
#   description    = "Compartment for OKE Dev Resources"
#   compartment_id = var.parent_compartment_id
#   enable_delete  = false
# }

resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_id
  cidr_block     = var.vcn_cidr
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label
}

resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = var.nat_display_name
}

resource "oci_core_service_gateway" "svc" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = var.svc_display_name

  services {
    service_id = data.oci_core_services.test_services.services[0]["id"]
  }
}



locals {
  private_route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_nat_gateway.nat.id
    },
    {
      destination       = data.oci_core_services.test_services.services[0]["cidr_block"]
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.svc.id
    }
  ]
}


resource "oci_core_route_table" "priv_rt" {
  for_each      = var.route_table_display_names
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = each.value

  dynamic "route_rules" {
    for_each = local.private_route_rules
    content {
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      network_entity_id = route_rules.value.network_entity_id
    }
  }
}

#Security Lists
# resource "oci_core_security_list" "sl" {
#   for_each       = var.security_lists
#   compartment_id = var.compartment_id
#   vcn_id         = oci_core_virtual_network.vcn.id
#   display_name   = each.value.display_name

#   # Ingress rules
#   dynamic "ingress_security_rules" {
#     for_each = each.value.ingress
#     content {
#       stateless   = ingress_security_rules.value.stateless
#       source      = ingress_security_rules.value.source
#       source_type = ingress_security_rules.value.source_type
#       protocol    = ingress_security_rules.value.protocol
#       description = ingress_security_rules.value.description

#       dynamic "tcp_options" {
#         for_each = ingress_security_rules.value.tcp_options != null ? [ingress_security_rules.value.tcp_options] : []
#         content {
#           min = tcp_options.value.min
#           max = tcp_options.value.max
#         }
#       }

#       dynamic "icmp_options" {
#         for_each = ingress_security_rules.value.icmp_options != null ? [ingress_security_rules.value.icmp_options] : []
#         content {
#           type = icmp_options.value.type
#           code = icmp_options.value.code
#         }
#       }
#     }
#   }

#   # Egress rules
#   dynamic "egress_security_rules" {
#     for_each = each.value.egress
#     content {
#       stateless        = egress_security_rules.value.stateless
#       destination      = egress_security_rules.value.destination
#       destination_type = egress_security_rules.value.destination_type
#       protocol         = egress_security_rules.value.protocol
#       description      = egress_security_rules.value.description

#       dynamic "tcp_options" {
#         for_each = egress_security_rules.value.tcp_options != null ? [egress_security_rules.value.tcp_options] : []
#         content {
#           min = tcp_options.value.min
#           max = tcp_options.value.max
#         }
#       }

#       dynamic "icmp_options" {
#         for_each = egress_security_rules.value.icmp_options != null ? [egress_security_rules.value.icmp_options] : []
#         content {
#           type = icmp_options.value.type
#           code = icmp_options.value.code
#         }
#       }
#     }
#   }
# }

locals {
  resolved_security_lists = {
    for sl_name, sl in var.security_lists : sl_name => {
      display_name = sl.display_name
      ingress      = sl.ingress
      egress       = [
        for rule in sl.egress : rule.destination == "ALL_IAD_SERVICES" ?
          merge(rule, { destination = data.oci_core_services.test_services.services[0].cidr_block }) :
          rule
      ]
    }
  }
}

resource "oci_core_security_list" "sl" {
  for_each       = local.resolved_security_lists
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = each.value.display_name

  dynamic "ingress_security_rules" {
    for_each = each.value.ingress
    content {
      stateless   = ingress_security_rules.value.stateless
      source      = ingress_security_rules.value.source
      source_type = ingress_security_rules.value.source_type
      protocol    = ingress_security_rules.value.protocol
      description = ingress_security_rules.value.description

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value.tcp_options != null ? [ingress_security_rules.value.tcp_options] : []
        content {
          min = tcp_options.value.min
          max = tcp_options.value.max
        }
      }

      dynamic "icmp_options" {
        for_each = ingress_security_rules.value.icmp_options != null ? [ingress_security_rules.value.icmp_options] : []
        content {
          type = icmp_options.value.type
          code = icmp_options.value.code
        }
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = each.value.egress
    content {
      stateless        = egress_security_rules.value.stateless
      destination      = egress_security_rules.value.destination
      destination_type = egress_security_rules.value.destination_type
      protocol         = egress_security_rules.value.protocol
      description      = egress_security_rules.value.description

      dynamic "tcp_options" {
        for_each = egress_security_rules.value.tcp_options != null ? [egress_security_rules.value.tcp_options] : []
        content {
          min = tcp_options.value.min
          max = tcp_options.value.max
        }
      }

      dynamic "icmp_options" {
        for_each = egress_security_rules.value.icmp_options != null ? [egress_security_rules.value.icmp_options] : []
        content {
          type = icmp_options.value.type
          code = icmp_options.value.code
        }
      }
    }
  }
}


resource "oci_core_subnet" "subnets" {
  for_each = var.subnets

  compartment_id             = var.compartment_id
  vcn_id                    = oci_core_virtual_network.vcn.id
  cidr_block                = each.value.cidr_block
  display_name              = each.value.display_name
  dns_label                 = each.value.dns_label

  route_table_id            = oci_core_route_table.priv_rt[each.value.route_table_key].id
  security_list_ids         = [oci_core_security_list.sl[each.value.security_list_key].id]

  prohibit_public_ip_on_vnic = true
}
