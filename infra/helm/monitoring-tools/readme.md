```bash
# Установка prometheus
cd prometheus
helm upgrade --install --atomic --namespace momo-store prometheus prometheus-community/prometheus -f values.yaml

# Установка grafana
cd grafana
helm upgrade --install --atomic --namespace momo-store grafana . -f values.yaml
# Пароль по умолчанию от Grafana admin\admin, необходимо его сменить при первом входе
```