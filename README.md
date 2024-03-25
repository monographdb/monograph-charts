## eloq operator Helm Chart

The current chart is for installing the eloq-operator (including CRD for `EloqDBCluster`) and the monitoring
infrastructure used by `EloqDBCluster`.

> NOTE: The monitoring infrastructure is optional and depends on whether it is already installed in your current
> environment. They come from the prometheus and grafana communities: prometheus, grafana, lock-distributed, mimir.

### Install the eloq-operator

[Helm](https://helm.sh) must be installed to use the charts. Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```shell
helm repo add eloqdata https://monographdb.github.io/monograph-charts/
helm repo update
# for example: helm install eloq-operator eloqdata/eloq-operator --namespace eloq-operator-system
helm install [RELEASE_NAME]  monographdb/eloq-operator --namespace [NAMESPACE_NAME]
```

> NOTE: If the installation specifies namespace please create it first.

### Check the installed eloq operator

```shell
# for example: helm list --namespace eloq-operator-system / helm list --all --all-namespaces
helm list --namespace [NAMESPACE_NAME]
```

### Uninstall Helm Release and CRDs

The default value of `keepCrds` in `values.yaml` is set to `true`. This means that even after uninstalling the release,
Custom Resource Definitions (CRDs) associated with the release are retained. This behavior is particularly useful for
preserving CRDs that you might want to keep for future use or to maintain data integrity.

To uninstall a Helm release, use the following command:

```shell
helm uninstall [RELEASE_NAME] --namespace [NAMESPACE_NAME]
```

In cases where you wish to delete the CRDs manually, use the following command:

``` shell
kubectl delete crd EloqDBClusters.monograph-service.monographdb.com
```

Alternatively, setting `keepCrds` to false will result in the automatic deletion of the associated CRDs when the Helm
release is uninstalled.

### eloq-operator chart arguments

The following parameters can be overridden by helm --set. For example: --set controllerManager.serviceAccoun="
eloq-op-sa"

| Name                                         | Type   | Default Value                       | Description                                                                                                 |
|----------------------------------------------|--------|-------------------------------------|-------------------------------------------------------------------------------------------------------------|
| nameOverride                                 | string | ""                                  | Overrides the "eloq-operator" with this name.                                                               |
| controllerManager.serviceAccount.name        | string | eloq-operator-controller-manager-sa | The service account name of the eloq operator controller manager pods.                                      |
| controllerManager.serviceAccount.annotations | object | {}                                  | Annotations for the `controllerManager.serviceAccount`.                                                     |
| controllerManager.image.repository           | string | monographdb/eloq-operator           | The image name of the eloq operator.                                                                        |
| controllerManager.image.tag                  | string | v1.0.4                              | The version tag for eloq operator docker image.                                                             |
| controllerManager.imagePullPolicy            | string | IfNotPresent                        | -                                                                                                           |
| controllerManager.imagePullSecrets           | object | {}                                  | -                                                                                                           |
| controllerManager.resources                  | object | Same format as k8s resource         | Resource requests and limits for eloq operator controller manager pods.                                     |
| controllerManager.healthPort                 | string | 18080                               | -                                                                                                           |
| controllerManager.metricPort                 | string | 18081                               | -                                                                                                           |
| controllerManager.watchNamespaces            | string | "" (watch all namespaces)           | Set the controller to watch specific namespaces instead of all. (e.g. `""`, `"NAMESPACE"`, or `"N1,N2,N3"`) |
| controllerManager.serviceMonitor.release     | string | kube-prometheus-stack               | Set the release name for the controller's metric service monitor.                                           |
| controllerManager.env                        | list   | []                                  | The environment variable of the eloq operator controller manager pods.                                      |
| keepCrds                                     | bool   | true                                | Keep or not keep CRDs when uninstalling the helm release.                                                   |
| cert-manager.enabled                         | bool   | false                               | Set `certManager.enabled=true` will install the cert-menager to `release.namespace`.                        |

### Install monitoring infrastructure

Currently, eloq-monitoring only supports AWS. It requires you to create a serviceAccount before execution
so that it can access AWS resources outside the EKS cluster. This includes S3.

```shell
# for example: helm install eloq-monitor-stack monographdb/eloq-monitoring --namespace eloq-monitoring-ns
helm install [RELEASE_NAME] monographdb/eloq-monitoring --namespace [NAMESPACE]
```

### eloq-monitoring chart arguments

| Name                                                                | Type   | Default value                   | Description                                             |
|---------------------------------------------------------------------|--------|---------------------------------|---------------------------------------------------------|
| global.namespace                                                    | string | eloq-monitoring-ns              | Monitor the namespace where the component is installed. |
| global.serviceAccount.name                                          | string | eloq-monitoring-sa              | ServiceAccount                                          |
| aws.region                                                          | string | ap-northeast-1                  | AWS configuration.                                      |
| aws.s3.endpoint                                                     | string | s3.ap-northeast-1.amazonaws.com | S3 endpoint.                                            |
| kube-prometheus-stack.enable                                        | bool   | true                            | If or not kube-prometheus-stack is installed.           |                                                        
| kube-prometheus-stack.storageSpec.storageClassName                  | string | ebs-sc-gp3                      |                                                         |
| kube-prometheus-stack.storageSpec.storageSize                       | string | 128Gi                           |                                                         |
| loki-distributed.enable                                             | bool   | true                            | If or not loki-distributed is installed.                |
| loki-distributed.bucketnames                                        | string | eloq-loki-data                  |                                                         |
| loki-distributed.ingester.persistence.walStorageSpec.size           | string | 12Gi                            |                                                         |
| loki-distributed.ingester.persistence.dataStorageSpec.size          | string | 12Gi                            |                                                         |
| loki-distributed.ingester.persistence.walStorageSpec.storageClass   | string | ebs-sc-gp3                      |                                                         |
| loki-distributed.ingester.persistence.dataStorageSpec.storageClass  | string | ebs-sc-gp3                      |                                                         |
| mimir-distributed.enabled                                           | bool   | true                            |                                                         |
| mimir-distributed.ingester.persistence.dataStorageSpec.storageClass | string | ebs-sc-gp3                      |                                                         |
| mimir-distributed.storageClass                                      | string | ebs-sc-gp3                      |                                                         |
| mimir-distributed.ruler_storage.bucket_name                         | string | eloq-mimir-ruler                | S3 bucketname of ruler_storage                          |
| mimir-distributed.alertmanager_storage.bucket_name                  | string | eloq-mimir-alertmanager         | S3 bucketname of alertmanager_storage                   |
| mimir-distributed.blocks_storage.bucket_name                        | string | eloq-mimir-data                 | S3 bucketname of blocks_storage                         |
| promtail.enable                                                     | bool   | true                            | If or not promtail is installed.                        |

> NOTE: All of the above S3 bucketname need to already exist.