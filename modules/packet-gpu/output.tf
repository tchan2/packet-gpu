output "node_address" {
  description = "GPU Node IP address"
  value       = "${packet_device.tf-gpu.network.0.address}"
}
