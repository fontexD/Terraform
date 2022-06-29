DOMAIN=fontex.dk
certbot certonly --manual -d *.$DOMAIN -d $DOMAIN --agree-tos --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --rsa-key-size 4096


DOMAIN='fontex.dk' sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'

CREATE USER 'admin'@'%'IDENTIFIED WITH mysql_native_password BY 'Datait2022!!';

    ALTER USER 'admin'@'%' IDENTIFIED BY 'Datait2022';


# Use Helm to deploy an NGINX ingress controller
helm install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-NGINX \
    --set controller.replicaCount=1


    tenantid=$(az account show --subscription "b39128ad-3a64-448f-8f4d-1b8da2556ee8" --query tenantId --output tsv)

    UserClientId=$(az aks show --name k8s-cluster-azure --resource-group aks-resource-group --query identityProfile.kubeletidentity.clientId -o tsv)
DNSID=$(az network dns zone show --name k8s.fontex.dk --resource-group aks-resource-group --query id -o tsv)

az role assignment create --assignee $UserClientId --role 'DNS Zone Contributor' --scope $DNSID