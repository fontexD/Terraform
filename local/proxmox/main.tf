terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "local" {}

#ip of proxmox-server
provider "proxmox" {
  pm_api_url = "https://<ip_of_proxmox>:8006/api2/json"
  pm_tls_insecure = true
}

module "haproxy" {
 
  source      = "./modules/template"
  count       = var.haproxy_instance_count
  node_name   = "haproxy-${count.index}"
  vm_id_start = 300 + count.index
  cpu_cores   = var.haproxy_cpu_cores
  memory_gb   = var.haproxy_memory_gb
  disk_gb     = var.haproxy_disk_gb
  storage     = var.storage
}


module "controller" {
  source      = "./modules/template"
  count       = var.controller_instance_count
  node_name   = "controller-${count.index}"
  vm_id_start = 100 + count.index
  cpu_cores   = var.controller_cpu_cores
  memory_gb   = var.controller_memory_gb
  disk_gb     = var.controller_disk_gb
  storage     = var.storage
}

module "worker" {
  source      = "./modules/template"
  count       = var.worker_instance_count
  node_name   = "worker-${count.index}"
  vm_id_start = 200 + count.index
  cpu_cores   = var.worker_cpu_cores
  memory_gb   = var.worker_memory_gb
  disk_gb     = var.worker_disk_gb
  storage     = var.storage
}

data "template_file" "tftp_config" {
  template = file("${path.module}/servers/tftp.tpl")

  vars = {
    haproxy     = "haproxy-0 ${module.haproxy[0].vm_ip}"
    workers     = join("\n", [for i, ip in module.worker[*].vm_ip : "worker-${i} ${ip}"])
    controllers = join("\n", [for i, ip in module.controller[*].vm_ip : "controller-${i} ${ip}"])
  }
}

resource "local_file" "tftp_config" {
  content  = data.template_file.tftp_config.rendered
  filename = "${path.root}/servers/server_ips.log"
}
