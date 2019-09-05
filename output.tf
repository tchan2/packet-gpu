output "GPU_Node_Info" {
  value = "\n\n Connect using: \n\n\t ssh user@${module.packet-gpu.node_address}"
}
