## monograph Operator Helm Chart

This chart is used to install `monograph operator` and `MonographDBCluster` related CRD. Please refer to the following
commands for details.

***Note: Currently only monograph operator installation is supported.***

### Install

[Helm](https://helm.sh) must be installed to use the charts. Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```shell
helm repo add monograph https://monographdb.github.io/monograph-charts/
helm repo update
# for example: helm install monograph-operator monograph/monograph-operator --namespace monograph-operator-system
helm install [RELEASE_NAME]  monograph/monograph-operator --namespace [NAMESPACE_NAME]
```

*Note: If the installation specifies namespace please create it first*

### Check the installed monograph Operator

```shell
# for example: helm list --namespace monograph-operator / helm list --all --all-namespaces
helm list --namespace [NAMESPACE_NAME]
```

### Uninstall Helm Release and CRDs
The default value of `keepCrds` in `values.yaml` is set to `true`. This means that even after uninstalling the release,
Custom Resource Definitions (CRDs) associated with the release are retained. This behavior is particularly useful for
preserving CRDs that you might want to keep for future use or to maintain data integrity.

To uninstall a Helm release, use the following command:
```shell
helm unstall [RELEASE_NAME] --namespace [NAMESPACE_NAME]
```

In cases where you wish to delete the CRDs manually, use the following command:

``` shell
kubectl delete crd monographdbclusters.monograph-service.monographdb.com
```

Alternatively, setting `keepCrds` to false will result in the automatic deletion of the associated CRDs when the Helm release is uninstalled.

### Chart Arguments

The following parameters can be overridden by helm --set. For example: --set controllerManager.serviceAccoun="
monograph-op-sa"

| Name                                         | Type   | Default Value                            | Description                                                                                                 |
|----------------------------------------------|--------|------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| nameOverride                                 | string | ""                                       | Overrides the "monograph-operator" with this name.                                                          |
| controllerManager.serviceAccount.name        | string | monograph-operator-controller-manager-sa | The service account name of the monograph operator controller manager pods.                                 |
| controllerManager.serviceAccount.annotations | object | {}                                       | Annotations for the `controllerManager.serviceAccount`.                                                     |
| controllerManager.image.repository           | string | monographdb/monograph-operator           | The image name of the monograph operator.                                                                   |
| controllerManager.image.tag                  | string | v1.0.4                                   | The version tag for monograph operator docker image.                                                        |
| controllerManager.imagePullPolicy            | string | IfNotPresent                             | -                                                                                                           |
| controllerManager.imagePullSecrets           | object | {}                                       | -                                                                                                           |
| controllerManager.resources                  | object | Same format as k8s resource              | Resource requests and limits for monograph operator controller manager pods.                                |
| controllerManager.healthPort                 | string | 18080                                    | -                                                                                                           |
| controllerManager.metricPort                 | string | 18081                                    | -                                                                                                           |
| controllerManager.watchNamespaces            | string | "" (watch all namespaces)                | Set the controller to watch specific namespaces instead of all. (e.g. `""`, `"NAMESPACE"`, or `"N1,N2,N3"`) |
| controllerManager.serviceMonitor.release     | string | kube-prometheus-stack                    | Set the release name for the controller's metric service monitor.                                           |
| controllerManager.env                        | list   | []                                       | The environment variable of the monograph operator controller manager pods.                                 |
| keepCrds                                     | bool   | true                                     | Keep or not keep CRDs when uninstalling the helm release.                                                   |
| cert-manager.enabled                         | bool   | false                                    | Set `certManager.enabled=true` will install the cert-menager to `release.namespace`.                        |
