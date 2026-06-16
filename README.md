# kubernetes-cluster-management
This setup contains two main folder: charts and scripts. The files in scripts are typically only ran once. These include the `vm-startup` script and argocd deployments. The charts folder contains three helm charts each tracks by the corresponding argocd. Argocd points to the local cluster it is deployed to in all cases.

## Management
Management is mostly a wrapper helm chart for `metrics-server`, `cert-manager`, and `ingress controller`. In the templates folder, `issuer` and `cluster issuer` are defined for `cert-manager`.

## Monitoring
This is a wrapper helm chart as well for `kube-prometheus-stack`. However, three specialized service monitors are defined for prometheus data collection in the templates folder. 

## Sample-app
This is a single docker image app. The chart is created for a simple app consisting of deployment, service and ingress. Currently, docker getting started docs are used as the image.

## CRDs
In order to make sure crds are up and running, there is a separate argocd definition pointing to `scripts/crds`. The crds are themselves downloaded in the folder to pin down the version. Currently the folder holds `cert-manger crds` and `kube-prometheus-crds`. 

## Reaching the Application

The current deployment of the application is limited by its self-signed certificate and lack of a proxy running on the VM. The webpage is available at [https://example.example.com:32151/](url), with dns resolution of 
```
86.38.238.174  example.example.com
```
