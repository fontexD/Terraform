# General variables
variable "storage" {
  description = "name of storage location"
  default     = "local-lvm"
}

# General variables
variable "target_node" {
  description = "name of storage location"
  default     = "lab02"
}

# Controller variables
variable "controller_instance_count" {
  description = "Number of controller instances"
  default     = 1
}

variable "controller_cpu_cores" {
  description = "Number of CPU cores for controller"
  default     = 2
}

variable "controller_memory_gb" {
  description = "Memory in GB for controller"
  default     = 2
}

variable "controller_disk_gb" {
  description = "Disk size in GB for controller"
  default     = 50
}

# Worker variables
variable "worker_instance_count" {
  description = "Number of worker instances"
  default     = 1
}

variable "worker_cpu_cores" {
  description = "Number of CPU cores for worker"
  default     = 2
}

variable "worker_memory_gb" {
  description = "Memory in GB for worker"
  default     = 12
}

variable "worker_disk_gb" {
  description = "Disk size in GB for worker"
  default     = 50
}

# HAProxy variables

variable "haproxy_instance_count" {
  description = "Number of HAProxy instances"
  default     = 1
}

variable "haproxy_cpu_cores" {
  description = "Number of CPU cores for HAProxy"
  default     = 2
}

variable "haproxy_memory_gb" {
  description = "Memory in GB for HAProxy"
  default     = 2
}

variable "haproxy_disk_gb" {
  description = "Disk size in GB for HAProxy"
  default     = 30
}
