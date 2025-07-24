variable "vcn_cidr" {

}

variable "vcn_display_name" {
  description = "Display name for the VCN"
  type        = string

}
variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
 
}

variable "vcn_dns_label" {
  description = "DNS label for the VCN"
  type        = string
  
}

variable "nat_display_name" {
  description = "Display name for the NAT Gateway"
  type        = string

}

variable "svc_display_name" {
  description = "Display name for the Service Gateway"
  type        = string

}


# Private Route Table display-names

variable "route_table_display_names" {
  description = "Map of each private route-table key to its display name"
  type        = map(string)
}


variable "security_lists" {
  description = "Map of security-list definitions, each including display_name, ingress and egress rules"
  type = map(object({
    display_name = string
    ingress = list(object({
      stateless   = bool
      source      = string
      source_type = string
      protocol    = string
      description = string
      tcp_options = optional(object({ min = number, max = number }))
      icmp_options = optional(object({ type = number, code = number }))
    }))
    egress = list(object({
      stateless        = bool
      destination      = string
      destination_type = string
      protocol         = string
      description      = string
      tcp_options = optional(object({ min = number, max = number }))
      icmp_options = optional(object({ type = number, code = number }))
    }))
  }))

}



variable "subnets" {
  description = "Map of subnets with CIDR, display name, dns label, route table key, and security list key"
  type = map(object({
    cidr_block         : string
    display_name       : string
    dns_label          : string
    route_table_key    : string
    security_list_key  : string
  }))

}
