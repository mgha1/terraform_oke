variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
 
}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}


variable "vcn_id" {
  description = "VCN OCID"
  type        = string
}

variable "kubapi_subnet_id" {
  description = "Subnet OCID for Kubernetes API endpoint"
  type        = string
}

variable "lb_subnet_id" {
  description = "Subnet OCID for Load Balancer"
  type        = string
}

variable "worker_subnet_id" {
  description = "Subnet OCID for worker nodes"
  type        = string
}

variable "pod_subnet_id" {
  description = "Subnet OCID for pods"
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "Name of the OKE cluster"

}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the cluster"

}



variable "node_pool_name" {
  type        = string
  description = "Name of the worker node pool"

}

variable "node_shape" {
  type        = string
  description = "Shape of the worker nodes (e.g., VM.Standard.E3.Flex)"

}

variable "node_count" {
  type        = number
  description = "Number of worker nodes in the node pool"

}

variable "boot_volume_size_in_gbs" {
  type        = number
  description = "Size of the boot volume for worker nodes (in GB)"

}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for accessing worker nodes"

}

variable "cni_type" {
  type        = string
  description = "CNI type for pod networking (e.g., OCI_VCN_IP_NATIVE)"

}

variable "is_public_ip_enabled" {
  type        = bool
  description = "Whether the Kubernetes API endpoint has a public IP"

}

variable "nsg_ids" {
  type        = list(string)
  description = "List of NSG IDs for the Kubernetes API endpoint and worker nodes"

}

variable "pod_nsg_ids" {
  type        = list(string)
  description = "List of NSG IDs for pods in the node pool"

}

variable "max_pods_per_node" {
  type        = number
  description = "Maximum number of pods per node (limited by VNIC count)"

}



variable "is_kubernetes_dashboard_enabled" {
  type        = bool
  description = "Whether to enable the Kubernetes Dashboard"

}



variable "cluster_type" {
  type        = string
  description = "Type of the OKE cluster (BASIC_CLUSTER or ENHANCED_CLUSTER)"

}

variable "node_pool_node_shape_config_ocpus" {
  type        = number

}

variable "node_pool_node_shape_config_memory_in_gbs" {
  type        = number

}
