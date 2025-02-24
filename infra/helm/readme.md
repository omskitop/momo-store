# Деплой приложения с локальной тачки

```bash
# Установка ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \
helm repo update && \
helm upgrade --install --atomic ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --version 4.12.0 \
  --set controller.service.type=LoadBalancer \
  --set controller.image.tag="v1.12.0" \
  --set controller.service.annotations."yandex\.cloud/load-balancer-type"=external

# Установка cert-manager
helm repo add jetstack https://charts.jetstack.io && \
helm repo update && \
helm upgrade --install --atomic cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.17.1  \
  --set crds.enabled=true

# values.yaml создаётся из values.yaml.tmpl с помощью envsubst переменными, значения которых можно взять из gitlab-settings-ci/cd-variables и поместить в .env файл, далее выполнить команды для каждого файла values.yaml.tmpl
export $(grep -v '^#' .env | xargs)
cat values.yaml.tmpl | envsubst > values.yaml

# Установка momo-store
helm upgrade --install --atomic momo-store-chart ./momo-store-chart \
  --namespace momo-store \
  --create-namespace \
  -f ./momo-store-chart/values.yaml

# Установка prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && \
helm repo update && \
helm upgrade --install prometheus prometheus-community/prometheus \
  --namespace momo-store \
  --create-namespace \
  -f ./monitoring-tools/prometheus/values.yaml

# Установка grafana
helm upgrade --install --atomic grafana ./monitoring-tools/grafana \
  --namespace momo-store \
  --create-namespace \
  -f ./monitoring-tools/grafana/values.yaml
# Пароль по умолчанию от Grafana admin\admin, необходимо его сменить при первом входе

# Получить внешний IP для ingress-nginx
kubectl get svc -n ingress-nginx -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}'
# Далее необходимо прописать в A-записи вида example.com, prometheus.example.com и grafana.example.com в настройках DNS-сервера, чтобы запросы к домену успешно обрабатывались ingress-nginx

# Удаление
helm uninstall ingress-nginx --namespace ingress-nginx && \
kubectl delete ns ingress-nginx

helm uninstall cert-manager --namespace cert-manager && \
kubectl delete ns cert-manager

helm uninstall momo-store-chart

helm uninstall prometheus --namespace momo-store

helm uninstall grafana --namespace momo-store

kubectl delete ns momo-store
```