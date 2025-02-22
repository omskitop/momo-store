# Local installlation

```bash
# Установка ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \
helm repo update && \
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --version 4.12.0 \
  --set controller.service.type=LoadBalancer \
  --set controller.image.tag="v1.12.0" \
  --set controller.service.annotations."yandex\.cloud/load-balancer-type"=external

# Установка cert-manager
helm repo add jetstack https://charts.jetstack.io && \
helm repo update && \
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.17.1  \
  --set crds.enabled=true

# Установка momo-store
helm upgrade --install --atomic --namespace momo-store --create-namespace momo-store-chart ./ -f ./values.yaml

# Получить внешний IP для ingress-nginx
kubectl get svc -n ingress-nginx -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}'
# Полученный IP необходимо прописать в A-запись DNS-сервера, чтобы запросы к домену успешно обрабатывались ingress-nginx

# Удаление
helm uninstall ingress-nginx -n ingress-nginx && \
kubectl delete ns ingress-nginx

helm uninstall cert-manager -n cert-manager && \
kubectl delete ns cert-manager

helm uninstall momo-store-chart
kubectl delete ns momo-store
```