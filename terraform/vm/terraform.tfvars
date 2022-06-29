# terraform.tfvars

# First we define how many controller nodes and worker nodes we want to deploy
vm-count = "3"

# VM Configuration
vm-prefix = "vm"
vm-template-name = "template"
vm-cpu = "2"
vm-ram = "2048"
vm-guest-id = "ubuntu64Guest"
vm-datastore = "data2"
vm-network = "VM Network"
vm-domain = "cluster.local"

# vSphere configuration
vsphere-vcenter = "192.168.10.50"
vsphere-unverified-ssl = "true"
vsphere-datacenter = "Datacenter"
vsphere-cluster = "cluster"

# vSphere username defined in environment variable
#export TF_VAR_vsphereuser=$(administrator@vsphere.local)

# vSphere password defined in environment variable
# export TF_VAR_vspherepass=$(Datait2022!!)
