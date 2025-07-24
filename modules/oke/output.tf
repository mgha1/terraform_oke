output "cluster_id" {
  description = "OCID of the created OKE cluster"
  value       = oci_containerengine_cluster.oke_cluster.id
}

output "node_pool_id" {
  description = "OCID of the worker node pool"
  value       = oci_containerengine_node_pool.oke_node_pool.id
}


output "node_pool" {
  value = {
    id                 = oci_containerengine_node_pool.oke_node_pool.id
    kubernetes_version = oci_containerengine_node_pool.oke_node_pool.kubernetes_version
    name               = oci_containerengine_node_pool.oke_node_pool.name
    subnet_ids         = oci_containerengine_node_pool.oke_node_pool.subnet_ids
  }
}

output "cluster" {
    value = {
        kubeconfig = data.oci_containerengine_cluster_kube_config.test_cluster_kube_config.content
    }
}