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

ДЗ #4 kubernetes-storage
https://github.com/kubernetes-csi/csi-driver-host-path
1) install csi-driver-host-path deploy-hostpath.sh # check kubectl get pods | grep csi-hostpath
2) create sc csi-hostpath-sc
3) create pvc csi-pvc
4) deploy pod 

ДЗ #5 kubernetes-debug
1) Отредактировал в манифесте версию образа на latest, strace так и не завелся, установил из бинарников \
export PLUGIN_VERSION=0.1.1 \
curl -Lo kubectl-debug.tar.gz https://github.com/aylei/kubectl-debug/releases/download/v${PLUGIN_VERSION}/kubectl-debug_${PLUGIN_VERSION}_linux_amd64.tar.gz \
tar -zxvf kubectl-debug.tar.gz kubectl-debug \
sudo mv kubectl-debug /usr/local/bin/\
kubectl-debug POD -n=namespace --agentless\
2) git clone https://github.com/piontec/netperf-operator\
cd netperf-operator\
kubectl create -f deploy/crd.yaml\
kubectl create -f deploy/rbac.yaml\
kubectl create -f deploy/operator.yaml\
kubectl apply -f cr.yaml\
kubectl describe netperf.app.example.com/example | grep Status\
kubectl apply -f https://raw.githubusercontent.com/express42/otus-platform-snippets/master/Module-03/Debugging/netperf-calico-policy.yaml \
3) Создание доступа для iptables-tailer, запуск ds\
