# terraform.tfvars

# First we define how many controller nodes and worker nodes we want to deploy
control-count = "3"
worker-count = "3"
etcd-count = "3"
haproxy-count = "1"

# VM Configuration
vm-prefix = "k8s"
vm-template-name = "k8s-template"
vm-cpu = "4"
vm-ram = "4096"
vm-guest-id = "ubuntu64Guest"
vm-datastore = "VM01"
vm-network = "Trusted"
vm-domain = "cluster.local"

# vSphere configuration
vsphere-vcenter = "vc02.proofficepark.dk"
vsphere-unverified-ssl = "true"
vsphere-datacenter = "Proofficepark"
vsphere-cluster = "Proofficepark"

# vSphere username defined in environment variable
#export TF_VAR_vsphereuser=$(administrator@vsphere.local)

# vSphere password defined in environment variable
# export TF_VAR_vspherepass=$(Datait2022!!)
