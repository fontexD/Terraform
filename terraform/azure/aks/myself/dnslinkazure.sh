echo ""
echo "Configuring Private DNS Link to Jumpbox VM"
CLUSTER_NAME=cluster-name
RG_NAME=aks-resource-group
VNET_DEST_ID=acctvnet

noderg=$(az aks show --name $CLUSTER_NAME \
    --resource-group $RG_NAME \
    --query 'nodeResourceGroup' -o tsv) 

dnszone=$(az network private-dns zone list \
    --resource-group $noderg \
    --query [0].name -o tsv)

az network private-dns link vnet create  --name k8slink  --resource-group $noderg --virtual-network $VNET_DEST_ID \
    --zone-name $dnszone \
    --registration-enabled false
