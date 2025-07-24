

# OKE Cluster
resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id

  cluster_pod_network_options {
    cni_type = var.cni_type  # OCI_VCN_IP_NATIVE
  }

  options {
    service_lb_subnet_ids = [var.lb_subnet_id]
  }

  endpoint_config {
    subnet_id = var.kubapi_subnet_id
  }
}

# Node Pool
resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = var.compartment_id
  name               = var.node_pool_name
  kubernetes_version = var.kubernetes_version
  node_shape         = var.node_shape


  node_source_details {
    image_id                = data.oci_core_images.node_images.images[0].id
    source_type             = "IMAGE"
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }
  
  node_config_details {
    #Required
    placement_configs {
      #Required
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.worker_subnet_id
    }
    size = var.node_count

    node_pool_pod_network_option_details {
        #Required
        cni_type = var.cni_type

        #Optional
        max_pods_per_node = var.max_pods_per_node
        pod_nsg_ids       = var.pod_nsg_ids
        pod_subnet_ids    = [var.pod_subnet_id]
      }
  }
  node_shape_config {

        #Optional
        memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
        ocpus = var.node_pool_node_shape_config_ocpus
    }


  ssh_public_key = var.ssh_public_key
}
