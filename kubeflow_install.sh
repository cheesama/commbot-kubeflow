#Download the kfctl v1.2.0 release from the Kubeflow releases page
#https://github.com/kubeflow/kfctl/releases/tag/v1.2.0
tar -xvf kfctl_<release tag>_<platform>.tar.gz

export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.2-branch/kfdef/kfctl_istio_dex.v1.2.0.yaml"

export KF_NAME=<your choice of name for the Kubeflow deployment>
mkdir -p ${KF_NAME}
cd ${KF_NAME}

kfctl apply -V -f ${CONFIG_URI}

# Download the dex config
kubectl get configmap dex -n auth -o jsonpath='{.data.config\.yaml}' > dex-config.yaml

# Edit the dex config with extra users.
# The password must be hashed with bcrypt with an at least 10 difficulty level.
# You can use an online tool like: https://passwordhashing.com/BCrypt

# After editing the config, update the ConfigMap
kubectl create configmap dex --from-file=config.yaml=dex-config.yaml -n auth --dry-run -oyaml | kubectl apply -f -

# Restart Dex to pick up the changes in the ConfigMap
kubectl rollout restart deployment dex -n auth

# connect exist container registry(in case of AKS & ACR)
az aks update -n myAKSCluster -g myResourceGroup --attach-acr <acr-name>
