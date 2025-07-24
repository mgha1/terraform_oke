output "services" {
  value = [data.oci_core_services.test_services.services]
}

output "vcn_id" {
  value = oci_core_virtual_network.vcn.id
}
output "subnet_ids" {
  description = "Map of subnet keys to their OCIDs"
  value = {
    for k, subnet in oci_core_subnet.subnets :
    k => subnet.id
  }
}
