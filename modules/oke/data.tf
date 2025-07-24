# Data source to fetch availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Data source to fetch the latest Oracle Linux 8 image for the node shape
data "oci_core_images" "node_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = var.node_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}


data "oci_containerengine_cluster_kube_config" "test_cluster_kube_config" {
    #Required
    cluster_id = oci_containerengine_cluster.oke_cluster.id
}