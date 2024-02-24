## Create a new cluster and configure the cluster agent nodes to use host-based encryption using --enable-encryption-at-host flag.

az aks create --name myAKSCluster --resource-group myResourceGroup -s Standard_DS2_v2 -l westus2--enable-encryption-at-host

## Enable host-based encryption on an existing cluster by adding a new node pool using the --enable-encryption-at-host flag.

az aks node pool add --name hostencrypt --cluster-name myAKSCluster --resource-group myResourceGroup -s Standard_DS2_v2 --enable-encryption-at-host





