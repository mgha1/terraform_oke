region               = "us-ashburn-1"
# add compartment_id
compartment_id       = ""





#Networking Vars
vcn_cidr             = "10.0.0.0/16"
vcn_display_name       = "vcn-okedev"
vcn_dns_label         = "okedev"
nat_display_name      = "ng-okedev"
svc_display_name      = "sg-okedev"





#OKE Vars
cluster_name = "oke-cluster-dev"
kubernetes_version   = "v1.32.1"
node_shape           = "VM.Standard.E3.Flex"
node_count           = 2
boot_volume_size_in_gbs = 50
node_pool_name = "oke-node-pool-dev"


#Enter your SSH Publick key here
ssh_public_key       = ""


cni_type             = "OCI_VCN_IP_NATIVE"
is_public_ip_enabled = false
nsg_ids              = []
pod_nsg_ids          = []
max_pods_per_node    = null
is_kubernetes_dashboard_enabled = false
cluster_type = "ENHANCED_CLUSTER"
node_pool_node_shape_config_memory_in_gbs = "16"
node_pool_node_shape_config_ocpus = "2"

