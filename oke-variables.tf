
variable "cluster_name" {
  type        = string
  description = "Name of the OKE cluster"
  default     = "oke-cluster-dev"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the cluster"
  default = "v1.32.1"
}



variable "node_pool_name" {
  type        = string
  description = "Name of the worker node pool"
  default     = "oke-node-pool-dev"
}

variable "node_shape" {
  type        = string
  description = "Shape of the worker nodes (e.g., VM.Standard.E3.Flex)"
  default = "VM.Standard.E3.Flex"
}

variable "node_count" {
  type        = number
  description = "Number of worker nodes in the node pool"
  default     = 2
}

variable "boot_volume_size_in_gbs" {
  type        = number
  description = "Size of the boot volume for worker nodes (in GB)"
  default     = 50
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for accessing worker nodes"
 
}

variable "cni_type" {
  type        = string
  description = "CNI type for pod networking (e.g., OCI_VCN_IP_NATIVE)"
  default     = "OCI_VCN_IP_NATIVE"
}

variable "is_public_ip_enabled" {
  type        = bool
  description = "Whether the Kubernetes API endpoint has a public IP"
  default     = false
}

variable "nsg_ids" {
  type        = list(string)
  description = "List of NSG IDs for the Kubernetes API endpoint and worker nodes"
  default     = []
}

variable "pod_nsg_ids" {
  type        = list(string)
  description = "List of NSG IDs for pods in the node pool"
  default     = []
}

variable "max_pods_per_node" {
  type        = number
  description = "Maximum number of pods per node (limited by VNIC count)"
  default     = null  # Let OKE use the default based on the shape
}



variable "is_kubernetes_dashboard_enabled" {
  type        = bool
  description = "Whether to enable the Kubernetes Dashboard"
  default     = false
}



variable "cluster_type" {
  type        = string
  description = "Type of the OKE cluster (BASIC_CLUSTER or ENHANCED_CLUSTER)"
  default     = "ENHANCED_CLUSTER"
}

variable "node_pool_node_shape_config_ocpus" {
  type        = number
  default     = "2"
}

variable "node_pool_node_shape_config_memory_in_gbs" {
  type        = number
  default     = "16"
}
