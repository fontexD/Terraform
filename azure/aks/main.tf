provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "k8s" {
  name     = "aks-resource-group"
  location = "germanywestcentral" 
}

module "network" {

  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.k8s.name
  address_space       = "10.52.0.0/16"
  subnet_prefixes     = ["10.52.0.0/24"]
  subnet_names        = ["subnet1"]
  depends_on          = [azurerm_resource_group.k8s]
}

data "azuread_group" "k8sAdminGroup" {
  display_name = "k8sAdminGroup"
}

module "aks" {
  source                                   = "Azure/aks/azurerm"
  resource_group_name                      = azurerm_resource_group.k8s.name
  client_id                                = ""
  client_secret                            = ""
  kubernetes_version                       = "1.23.5"
  orchestrator_version                     = "1.23.5"
  prefix                                   = "prefix"
  cluster_name                             = "k8s-cluster-azure"
  network_plugin                           = "azure"
  vnet_subnet_id                           = module.network.vnet_subnets[0]
  os_disk_size_gb                          = 50
  sku_tier                                 = "Paid" # defaults to Free
  enable_role_based_access_control = true
  rbac_aad_admin_group_object_ids          = [data.azuread_group.k8sAdminGroup.id]
  rbac_aad_managed                         = true
  private_cluster_enabled                  = false # default value
  enable_http_application_routing          = true
  enable_azure_policy                      = true
  enable_auto_scaling                      = true
  enable_host_encryption                   = false
  agents_min_count                         = 1
  agents_max_count                         = 2
  agents_count                             = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                          = 100
  agents_pool_name                         = "exnodepool"
  agents_availability_zones                = ["1", "2"]
  agents_type                              = "VirtualMachineScaleSets"

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  enable_ingress_application_gateway = true
  ingress_application_gateway_name = "aks-agw"
  ingress_application_gateway_subnet_cidr = "10.52.1.0/24"

  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.0.0.0/16"

  depends_on = [module.network]
} 
