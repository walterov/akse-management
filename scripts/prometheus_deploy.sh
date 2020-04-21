#!/bin/bash 

# Chech if Prometheus is required
echo "Chech if Prometheus is required"

if [ "$MONITORING_PROMETHEUS" == "TRUE" ]; then
    #check is helm has already being installed
    if ! [ -x "$(command -v helm)" ]; then
        if [[ "${OSTYPE}" == "linux-gnu" ]]; then
        echo "helm not found, installing"
        # Install helm 3
            wget -O helm-v3.0.0-beta.4-linux-amd64.tar.gz https://get.helm.sh/helm-v3.0.0-beta.4-linux-amd64.tar.gz
            tar -zxvf helm-v3.0.0-beta.4-linux-amd64.tar.gz
            sudo mv ./linux-amd64/helm /usr/local/bin/helm
        else
        echo "Missing required binary in path: helm"
        return 2
        fi
    else
        echo "Helm is available"    
    fi

    # Ensure we have the latest establed helm repo
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    helm repo update

    # TODO: <fix> introduce sleep time to avoid the cluster not being ready for helm
    sleep 1m

    # install Prometheus
    echo "install Prometheus"
    helm install my-prometheus stable/prometheus --set server.service.type=LoadBalancer --set rbac.create=false

    # Give cluster admin to Prometheus 
    kubectl create clusterrolebinding my-prometheus-server --clusterrole=cluster-admin --serviceaccount=default:my-prometheus-server

    # TODO: <fix> introduce sleep time to avoid issues with two services deploying at the same time
    sleep 2m

    # Install Grafana
    echo "install Grafana"
    helm install my-grafana stable/grafana --set service.type=LoadBalancer --set rbac.create=false
    
    # Get secret for Grafana portal
    echo "Get secret for Grafana portal"
    kubectl get secret --namespace default my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    
    # dashboard IP addresses
    kubectl get services
else
    echo "Helm and Prometheus were not installed "
fi




