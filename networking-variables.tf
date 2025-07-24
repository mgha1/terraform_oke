variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "vcn_display_name" {
  description = "Display name for the VCN"
  type        = string
  default     = "vcn-okedev"
}
variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
  default = "ocid1.compartment.oc1..aaaaaaaa356x4ozeuu2ou3akcz2xnm7npmlc35lcp2ypwequdhzp3x76toiq"
}

variable "vcn_dns_label" {
  description = "DNS label for the VCN"
  type        = string
  default     = "okedev"
}

variable "nat_display_name" {
  description = "Display name for the NAT Gateway"
  type        = string
  default     = "ng-okedev"
}

variable "svc_display_name" {
  description = "Display name for the Service Gateway"
  type        = string
  default     = "sg-okedev"
}


# Private Route Table display-names

variable "route_table_display_names" {
  description = "Map of each private route-table key to its provided display name"
  type        = map(string)
  default = {
    kubapi     = "rt-okedev-kubapi-priv"
    workernode = "rt-okedev-workernode-priv"
    pod        = "rt-okedev-pod-priv"
    lb         = "rt-okedev-lb-priv"
  }
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
  default = {sl_kubapi = {
    display_name = "sl-okedev-kubapi-priv"
    ingress = [
      { stateless = false, source = "10.0.1.0/24", source_type = "CIDR_BLOCK", protocol = "6", description = "Kubernetes worker to Kubernetes API endpoint communication", tcp_options = { min = 6443, max = 6443 } },
      { stateless = false, source = "10.0.1.0/24", source_type = "CIDR_BLOCK", protocol = "6", description = "Kubernetes worker to Kubernetes API endpoint communication", tcp_options = { min = 12250, max = 12250 } },
      { stateless = false, source = "10.0.32.0/19", source_type = "CIDR_BLOCK", protocol = "6", description = "Pod to Kubernetes API endpoint communication (VCN-native pod networking)", tcp_options = { min = 6443, max = 6443 } },
      { stateless = false, source = "10.0.32.0/19", source_type = "CIDR_BLOCK", protocol = "6", description = "Pod to Kubernetes API endpoint communication (VCN-native pod networking)", tcp_options = { min = 12250, max = 12250 } },
      { stateless = false, source = "10.0.1.0/24", source_type = "CIDR_BLOCK", protocol = "1", description = "Path Discovery", icmp_options = { type = 3, code = 4 } }
    ]
    egress = [
      { stateless = false, destination = "ALL_IAD_SERVICES", destination_type = "SERVICE_CIDR_BLOCK", protocol = "6", description = "Allow Kubernetes API endpoint to communicate with OKE", tcp_options = { min = 443, max = 443 } },
      { stateless = false, destination = "10.0.32.0/19", destination_type = "CIDR_BLOCK", protocol = "all", description = "Kubernetes API endpoint to pod communication (VCN-native pod networking)" },
      { stateless = false, destination = "10.0.1.0/24", destination_type = "CIDR_BLOCK", protocol = "1", description = "Path Discovery", icmp_options = { type = 3, code = 4 } },
      { stateless = false, destination = "10.0.1.0/24", destination_type = "CIDR_BLOCK", protocol = "6", description = "Kubernetes API endpoint to worker node communication (VCN-native pod networking)", tcp_options = { min = 10250, max = 10250 } }
    ]
  }

  sl_workernode = {
    display_name = "sl-okedev-workernode-priv"
    ingress = [
      { stateless = false, source = "10.0.1.0/24", source_type = "CIDR_BLOCK", protocol = "all", description = "Allows communication from (or to) worker nodes" },
      { stateless = false, source = "10.0.32.0/19", source_type = "CIDR_BLOCK", protocol = "all", description = "Allow pods on one worker node to communicate with pods on other worker nodes (VCN-native pod networking)" },
      { stateless = false, source = "10.0.0.0/29", source_type = "CIDR_BLOCK", protocol = "6", description = "Allow Kubernetes API endpoint to communicate with worker nodes" },
      { stateless = false, source = "0.0.0.0/0", source_type = "CIDR_BLOCK", protocol = "1", description = "Path Discovery", icmp_options = { type = 3, code = 4 } },
      { stateless = false, source = "10.0.0.0/29", source_type = "CIDR_BLOCK", protocol = "6", description = "Kubernetes API endpoint to worker node communication (VCN-native pod networking)", tcp_options = { min = 10250, max = 10250 } },
      { stateless = false, source = "0.0.0.0/0", source_type = "CIDR_BLOCK", protocol = "6", description = "(optional) Allow inbound SSH traffic to worker nodes", tcp_options = { min = 22, max = 22 } },
      { stateless = false, source = "10.0.2.0/24", source_type = "CIDR_BLOCK", protocol = "all", description = "Allow OCI load balancer or network load balancer to communicate with kube-proxy on worker nodes" }
    ]
    egress = [
      { stateless = false, destination = "10.0.1.0/24", destination_type = "CIDR_BLOCK", protocol = "all", description = "Allows communication from (or to) worker nodes" },
      { stateless = false, destination = "10.0.32.0/19", destination_type = "CIDR_BLOCK", protocol = "all", description = "Allow worker nodes to communicate with pods on other worker nodes (VCN-native pod networking)" },
      { stateless = false, destination = "0.0.0.0/0", destination_type = "CIDR_BLOCK", protocol = "all", description = "Allow internet access from worker nodes (NATed)" }
    ]
  }

  sl_lb = {
    display_name = "sl-okedev-lb-priv"
    ingress = [
      { stateless = false, source = "0.0.0.0/0", source_type = "CIDR_BLOCK", protocol = "6", description = "Inbound HTTP access", tcp_options = { min = 80, max = 80 } },
      { stateless = false, source = "0.0.0.0/0", source_type = "CIDR_BLOCK", protocol = "6", description = "Inbound HTTPS access", tcp_options = { min = 443, max = 443 } }
    ]
    egress = [
      { stateless = false, destination = "10.0.1.0/24", destination_type = "CIDR_BLOCK", protocol = "all", description = "LB to worker nodes" },
      { stateless = false, destination = "0.0.0.0/0", destination_type = "CIDR_BLOCK", protocol = "all", description = "Allow LB to access internet (NATed)" }
    ]
  }

  sl_pod = {
    display_name = "sl-okedev-pod-priv"
    ingress = [
      { stateless = false, source = "10.0.32.0/19", source_type = "CIDR_BLOCK", protocol = "all", description = "Allow pod-to-pod communication (VCN-native pod networking)" }
    ]
    egress = [
      { stateless = false, destination = "10.0.32.0/19", destination_type = "CIDR_BLOCK", protocol = "all", description = "Allow pod-to-pod communication (VCN-native pod networking)" },
      { stateless = false, destination = "0.0.0.0/0", destination_type = "CIDR_BLOCK", protocol = "all", description = "Allow pods to access the internet (via NAT)" }
    ]
  }

  sl_bastion = {
    display_name = "sl-okedev-bastion-priv"
    ingress = [
      { stateless = false, source = "0.0.0.0/0", source_type = "CIDR_BLOCK", protocol = "6", description = "Allow SSH", tcp_options = { min = 22, max = 22 } }
    ]
    egress = [
      { stateless = false, destination = "0.0.0.0/0", destination_type = "CIDR_BLOCK", protocol = "all", description = "Allow bastion to reach anywhere" }
    ]
  }}
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
  default = {
    kubapi = {
      cidr_block        = "10.0.0.0/29"
      display_name      = "sn-okedev-kubapi-priv"
      dns_label         = "kubapi"
      route_table_key   = "kubapi"
      security_list_key = "sl_kubapi"
    }
    workernode = {
      cidr_block        = "10.0.1.0/24"
      display_name      = "sn-okedev-workernode-priv"
      dns_label         = "worker"
      route_table_key   = "workernode"
      security_list_key = "sl_workernode"
    }
    pod = {
      cidr_block        = "10.0.32.0/19"
      display_name      = "sn-okedev-pod-priv"
      dns_label         = "pod"
      route_table_key   = "pod"
      security_list_key = "sl_pod"
    }
    lb = {
      cidr_block        = "10.0.2.0/24"
      display_name      = "sn-okedev-lb-priv"
      dns_label         = "lb"
      route_table_key   = "lb"
      security_list_key = "sl_lb"
    }
  }
}
