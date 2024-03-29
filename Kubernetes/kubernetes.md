AKSRG='aks-01-RG'
LOCATION='eastus'
az group create --name $AKSRG --location $LOCATION

## To create an AKS cluster, run the following commands:
AKSNAME='aks-01'
az aks create --resource-group $AKSRG --name $AKSNAME --enable-managed-identity --node-count 1 --generate-ssh-keys

## Once the cluster provisioning completes, to connect to the AKS cluster, run the following command:
az aks get-credentials --resource-group $AKSRG --name $AKSNAME

## To verify that the connection was successful, run the following command:
kubectl get nodes

##  To install the Azure Policy add-on, you need to ensure that the Microsoft.PolicyInsights resource provider is registered in your subscription. 
##  From the Bash session in the Azure Cloud Shell in the Azure portal, run the following commands to verify:

az provider register --namespace Microsoft.PolicyInsights
az provider show --namespace Microsoft.PolicyInsights --output table


## To install the add-on, run the following commands:
AKSRG='aks-01-RG'
AKSNAME='aks-01'
az aks enable-addons --addons azure-policy --name $AKSNAME --resource-group $AKSRG

## To validate that the add-on installation was successful and that the azure-policy and gatekeeper pods are operational, run the following commands:
kubectl get pods --namespace kube-system
kubectl get pods --namespace gatekeeper-system

## To verify that, at this point, no Azure Policy constraints are applied to the target cluster, run the following command:
kubectl get constrainttemplates


## Assign an Azure Policy initiative to an AKS cluster


## Validate the effect of Azure Policy

## Attempt deploying a pod based on the YAML manifest by running the following command:

kubectl apply -f nginx-privileged.yaml

## Verify that the deployment fails with an error message that resembles the following one.

Error from server (Forbidden): error when creating "nginx-privileged.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [azurepolicy-k8sazurev2noprivilege-a759592cb6adc510dcfa] Privileged container isn't allowed: nginx-privileged, securityContext: {"privileged": true}


kubectl apply -f premium-storage-class.yaml

kubectl apply -f persistent-volume-claim-5g.yaml

kubectl apply -f pod-with-storage-mount.yaml

## Validate the effect of the volume mount

kubectl get pods

## To list the content of the /mnt/azure directory, run the following command:
kubectl exec -i nginx -- sh -c "ls /mnt/azure"

## To create a file named hello containing a single line of text 'Hello world', run the following command:

kubectl exec -i nginx -- sh -c "echo 'Hello world' > /mnt/azure/hello"

## To list the content of the /mnt/azure directory (this time including the newly created hello file, run the following command:

kubectl exec -i nginx -- sh -c "ls /mnt/azure"

## To delete the nginx pod, run the following command:
kubectl delete pod nginx

## Now, re-create the nginx pod by running the following command:
kubectl apply -f pod-with-storage-mount.yaml

## Finally, verify that the content of the mount is intact by running the following command:
kubectl exec -i nginx -- sh -c "ls /mnt/azure"


## Delete the resources provisioned in the exercise
kubectl get pvc
kubectl delete pvc azure-managed-disk

## To list and delete the storage class, run the following commands:

kubectl get sc
kubectl delete sc managed-premium-retain


## From the Azure portal, open a Bash session in the Azure Cloud Shell and run the following commands.
kubectl create namespace demo-deployment
kubectl get namespaces

## Run the following command to add a node to the AKS cluster.
az aks show --resource-group $AKSRG --name $AKSNAME --query agentPoolProfiles
az aks scale --resource-group $AKSRG --name $AKSNAME --node-count 2 --nodepool-name nodepool1

## To create the deployment, from the Bash session in the Azure Cloud Shell, run the following command:
kubectl apply -f nginx-deployment.yaml --namespace demo-deployment


## To validate the deployment, enumerate deployments, pods, and replica sets by running the following commands:
kubectl get deployments --namespace demo-deployment
kubectl get pods --namespace demo-deployment
kubectl get rs --namespace demo-deployment

## Update the deployment

## To replace the image used by our deployment, from the Bash session in the Azure Cloud Shell, run the following command:

kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1 --namespace demo-deployment

## To validate the deployment, enumerate deployments, pods, and replica sets by running the following commands:

kubectl get deployments --namespace demo-deployment
kubectl get pods --namespace demo-deployment
kubectl get rs --namespace demo-deployment

## Roll back the deployment

## To display the deployment properties, run the following command:
kubectl describe deployment

## To roll back the deployment, run the following command:
kubectl rollout undo deployment/nginx-deployment --namespace demo-deployment

## o validate the rollback enumerate deployments, pods, and replica sets by running the following commands:
kubectl get deployments --namespace demo-deployment
kubectl get pods --namespace demo-deployment
kubectl get rs --namespace demo-deployment

## Delete the resources provisioned in the module
AKSRG='aks-01-RG'
az group show --name $AKSRG

## To delete the resource group you referenced in the previous step, run the following command:
az group delete --name $AKSRG --no-wait --yes



## Enable the cluster autoscaler on a new cluster

az group create --name myResourceGroup --location eastus

az aks create \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --node-count 1 \
    --vm-set-type VirtualMachineScaleSets \
    --load-balancer-sku standard \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3


## Enable the cluster autoscaler on an existing cluster

az aks update \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3


## Disable the cluster autoscaler on a cluster

az aks update \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --disable-cluster-autoscaler




