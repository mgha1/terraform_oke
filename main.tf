module "networking" {
  source = "./modules/networking"

  compartment_id           = var.compartment_id
  vcn_cidr                 = var.vcn_cidr
  vcn_display_name         = var.vcn_display_name
  vcn_dns_label            = var.vcn_dns_label
  nat_display_name         = var.nat_display_name
  svc_display_name         = var.svc_display_name
  route_table_display_names = var.route_table_display_names
  security_lists           = var.security_lists
  subnets                  = var.subnets
}

module "oke" {
  source = "./modules/oke"

  # Outputs from networking module
  vcn_id           = module.networking.vcn_id
  kubapi_subnet_id = module.networking.subnet_ids["kubapi"]
  lb_subnet_id     = module.networking.subnet_ids["lb"]
  worker_subnet_id = module.networking.subnet_ids["workernode"]
  pod_subnet_id    = module.networking.subnet_ids["pod"]

  # Local variables
  compartment_id                     = var.compartment_id
  vcn_cidr                           = var.vcn_cidr
  cluster_name                       = var.cluster_name
  kubernetes_version                = var.kubernetes_version
  node_pool_name                    = var.node_pool_name
  node_shape                        = var.node_shape
  node_count                        = var.node_count
  boot_volume_size_in_gbs          = var.boot_volume_size_in_gbs
  ssh_public_key                    = var.ssh_public_key
  cni_type                          = var.cni_type
  is_public_ip_enabled             = var.is_public_ip_enabled
  nsg_ids                           = var.nsg_ids
  pod_nsg_ids                       = var.pod_nsg_ids
  max_pods_per_node                = var.max_pods_per_node
  is_kubernetes_dashboard_enabled = var.is_kubernetes_dashboard_enabled
  cluster_type                      = var.cluster_type
  node_pool_node_shape_config_ocpus         = var.node_pool_node_shape_config_ocpus
  node_pool_node_shape_config_memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
}
