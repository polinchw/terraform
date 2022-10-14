## variables.tf
variable "vm_names" {
  description = "List of VMs that needs to be scheduled for start / start"
  type        = list(string)
  default     = ["devcoops-web1"]
}