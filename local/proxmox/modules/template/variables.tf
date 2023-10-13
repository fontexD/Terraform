variable "node_name" {
  description = "Name of the node"
  type        = string
}

variable "target_node" {
  description = "name of the server in proxmox"
  type        = string
}

variable "storage" {
  description = "Name of the storage"
  type        = string
}

variable "vm_id_start" {
  description = "VM ID start value"
  type        = number
  default     = 1
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory_gb" {
  description = "Memory in GB"
  type        = number
}

variable "disk_gb" {
  description = "Disk size in GB"
  type        = number
}

