terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

locals {
  ssh_key_private = file("~/.ssh/id_rsa")

  ssh_key_pub = file("~/.ssh/id_rsa.pub")
}


resource "proxmox_vm_qemu" "node" {
    name = var.node_name
    target_node = var.target_node
    clone = "ubuntu-template"
    agent = 1
    os_type = "cloud-init"

    #Hardware Spec
    scsihw = "virtio-scsi-pci"
    cores = var.cpu_cores
    sockets = 1
    cpu = "x86-64-v2-AES"
    memory = var.memory_gb * 1024


    #HardDrive Spec
    disk {
        size = "${var.disk_gb}G"
        format = "raw"
        type = "virtio"
        storage = var.storage
        iothread = 1
    }

    #Networking
    network {
        model = "virtio"
        bridge = "vmbr0"
    }
    ipconfig0   = "ip=dhcp"
#    ipconfig0 = "ip=192.168.1.57/24,gw=192.168.1.1"
    ssh_user        = "ubuntu"

    #Private key certificate that matches your public key, for pub authentication
    ssh_private_key = local.ssh_key_private
    #Pub_key
    sshkeys = local.ssh_key_pub
  connection {
    type        = "ssh"
    host        = self.ssh_host
    user        = self.ssh_user
    private_key = self.ssh_private_key
    port        = self.ssh_port
  }


}


output "vm_ip" {
  value = proxmox_vm_qemu.node.ssh_host
  description = "The IP address of the created VM"
}

output "vm_name" {
  value = proxmox_vm_qemu.node.name
  description = "The name of the created VM"
}
