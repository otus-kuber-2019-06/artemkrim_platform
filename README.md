# artemkrim_platform
artemkrim Platform repository

ДЗ №1 kubernetes-intro
1) Установка kubectl
2) Установка minikube
3) Запуск minikube
4) Проверка конфигурации - config view, проверка подключения к кластеру - cluster-info
5) Установка дашбордов
6) Проверка отказоустойчивости (coredns - ReplicaSet, /etc/kubernetes/manifests - static manifests)
7) Создание docker image на основе alpine-nginx, push dockerhub
8) Создание манифеста web-pod.yaml
9) Добавление init контейнера в манифест
10) Проброс порта 8000 \
Рузультат http://127.0.0.1:8000/index.html

ДЗ №2 kubernetes-security
1) Создание sa bob с добавление в группу admin
2) Создание sa dave
3) Создание ns prometheus
4) Создание sa carol
5) Создание роли с правами на чтение всех подов
6) Добавление всех sa prometheus в созданную группу на чтение всех подов
7) Создание ns dev
8) Создание sa jane, права admin ns-dev
9) Создание sa ken, права view ns-dev

ДЗ №3 kubernetes-networks
1) Добавление проверок web-pod
2) Создание Deploymen web
3) Создание Service web
4) active ipvs
5) apply metallb
6) меняем ClusterIP на LoadBalancer
7) kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
8) создан ingress-lb
9) создан Headless для web pods
10) proxy ingress url /web

ДЗ №4 kubernetes-volumes
1) Установлен kind
2) Создан StatefulSet minio
3) Coздан headless сервис для minio
4) Создан secret, содержащий access_key и secret_key | base64

ДЗ #5 kubernetes-storage
https://github.com/kubernetes-csi/csi-driver-host-path
1) install csi-driver-host-path deploy-hostpath.sh # check kubectl get pods | grep csi-hostpath
2) create sc csi-hostpath-sc
3) create pvc csi-pvc
4) deploy pod 

ДЗ #6 kubernetes-debug
1) Отредактировал в манифесте версию образа на latest, strace так и не завелся, установил из бинарников \
export PLUGIN_VERSION=0.1.1 \
curl -Lo kubectl-debug.tar.gz https://github.com/aylei/kubectl-debug/releases/download/v${PLUGIN_VERSION}/kubectl-debug_${PLUGIN_VERSION}_linux_amd64.tar.gz \
tar -zxvf kubectl-debug.tar.gz kubectl-debug \
sudo mv kubectl-debug /usr/local/bin/\
kubectl-debug POD -n=namespace --agentless
2) git clone https://github.com/piontec/netperf-operator \
cd netperf-operator\
kubectl create -f deploy/crd.yaml\
kubectl create -f deploy/rbac.yaml\
kubectl create -f deploy/operator.yaml\
kubectl apply -f cr.yaml\
kubectl describe netperf.app.example.com/example | grep Status\
kubectl apply -f https://raw.githubusercontent.com/express42/otus-platform-snippets/master/Module-03/Debugging/netperf-calico-policy.yaml 
3) Создание доступа для iptables-tailer, запуск ds

ДЗ #7 kubernetes-operators
```
1) применяем манифесты crd & cr 

root@m1:/home/smile# kubectl get pvc -A 
NAMESPACE   NAME                        STATUS   VOLUME                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE\
default     backup-mysql-instance-pvc   Bound    backup-mysql-instance-pv   1Gi        RWO                           5s\
default     mysql-instance-pvc          Bound    mysql-instance-pv          1G         RWO                           5s\

2) заполняем бд

root@m1:/home/smile# export MYSQLPOD=$(kubectl get pods -l app=mysql-instance -o jsonpath="{.items[*].metadata.name}")
root@m1:/home/smile# kubectl exec -it $MYSQLPOD -- mysql -u root -potuspassword -e "CREATE TABLE test ( id smallint unsigned not null auto_increment, name varchar(20) not null, constraint pk_example primary key (id) );" otus-database
mysql: [Warning] Using a password on the command line interface can be insecure.
root@m1:/home/smile# kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "INSERT INTO test ( id, name ) VALUES ( null, 'some data' );" otus-database
mysql: [Warning] Using a password on the command line interface can be insecure.
root@m1:/home/smile# kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "INSERT INTO test ( id, name ) VALUES ( null, 'some data-2' );" otus-database
mysql: [Warning] Using a password on the command line interface can be insecure.
root@m1:/home/smile# kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "select * from test;" otus-database
mysql: [Warning] Using a password on the command line interface can be insecure.
+----+-------------+
| id | name        |
+----+-------------+
|  1 | some data   |
|  2 | some data-2 |
+----+-------------+

3) удаляем mysql-instance

root@m1:/home/smile# kubectl delete mysqls.otus.homework mysql-instance
mysql.otus.homework "mysql-instance" deleted
root@m1:/home/smile# kubectl get pv
NAME                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                               STORAGECLASS   REASON   AGE
backup-mysql-instance-pv   1Gi        RWO            Retain           Bound    default/backup-mysql-instance-pvc                           14m
root@m1:/home/smile# kubectl get jobs.batch
NAME                         COMPLETIONS   DURATION   AGE
backup-mysql-instance-job    1/1           3s         72s

4) применяем манифест cr, проверяем
+----+-------------+
| id | name        |
+----+-------------+
|  1 | some data   |
|  2 | some data-2 |
+----+-------------+

ДЗ #10 kubernetes-templating
Кластер развернут с помощью kubespray \
v1.16.2\
3-master\
2-worker\
2-ingress(VRRP)\

1) helm 2.14.3 установлен kubespray, инициализируем tiller
kubectl apply -f tiller.yaml\
helm init --service-account=tiller\
2) устанавливаем nginx-ingress с помощью helm
```
helm install --name=nginx-ingress stable/nginx-ingress --version 1.24.2 \
--namespace=ingress-nginx \
--set controller.kind=DaemonSet \
--set controller.service.type="" \
--set controller.daemonset.useHostPort=true \
--set controller.daemonset.hostPorts.http=80 \
--set controller.daemonset.hostPorts.https=443 \
--set controller.nodeSelector."node\.kubernetes\.io/ingress"="" \
--set defaultBackend.nodeSelector."node\.kubernetes\.io/ingress"="" \
--set defaultBackend.replicaCount=2
3) устанавливаем cert-manager
```
kubectl create namespace cert-manager
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm upgrade --install cert-manager jetstack/cert-manager --version=0.11.0 \
--namespace=cert-manager \
--set nodeSelector."node\.kubernetes\.io/ingress"=""
kubectl apply -f ClusterIssuer.yaml
4) устанавливаем плагин helm-tiller
5) попробовали установить чарт в secret, затем в configMap
export HELM_TILLER_STORAGE=configmap
```
helm tiller run \
helm upgrade --install chartmuseum stable/chartmuseum --wait \
--namespace=chartmuseum \
--version=2.4.0 \
-f values.yaml
6) установка helm3 \
version.BuildInfo{Version:"v3.0.0-rc.1", GitCommit:"ee77ae3d40fd599445ebd99b8fc04e2c86ca366c", GitTreeState:"clean", GoVersion:"go1.13.3"} \
7) устанавливаем harbor \
kubectl create ns harbor \
helm3 upgrade --install harbor harbor/harbor --wait \
--namespace=harbor \
--version=1.1.3 \
-f values.yaml \
8) создаем chart socks-shop\
helm create kubernetes-templating/socks-shop\
helm upgrade --install socks-shop kubernetes-templating/socks-shop --namespace=socks-shop\
9) выносим frontend в отдельный chart\
helm create kubernetes-templating/frontend\
helm upgrade --install socks-shop kubernetes-templating/frontend --namespace=socks-shop\
10) переустанавливаем chart socks-shop\
helm upgrade --install socks-shop kubernetes-templating/socks-shop --namespace=socks-shop\
11) шаблонизируем fronend\
12) создаем зависимость \
13) шаблонизируем с помощью kubecfg\
14) шаблонизируем с помощью kustomize