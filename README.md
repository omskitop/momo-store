# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

# Ссылки
[omskitop.ru](https://omskitop.ru) - развернутый momo-store

[prometheus.omskitop.ru](https://prometheus.omskitop.ru) - развернутый prometheus

[grafana.omskitop.ru](https://grafana.omskitop.ru) - развернутый grafana(дашборды в разработке)

# CI/CD
- Код приложения и инфраструктуры находится в этом репозитории для простоты и удобства.
- Развертывание инфраструктуры и приложения выполняется через Gitlab CI/CD pipeline.
- Pipeline модульный и при изменении кода в соответствующих директориях тригеррятся модули, выполняющие соответствующие джобы.
- Все этапы CI/CD описаны в файле .gitlab-ci.yml и максимально упрощены, т.к. простой код легче поддерживать. При необходимости всегда можно добавить дополнительные этапы и джобы.
- Для внесения изменений в код используется git-flow с основной веткой master, в которую сливаются ветки, содержащие завершенные изменения по задачам.

# Версионирование
- Используется стандарт SemVer 2.0.0
- Мажорные и минорные версии приложения изменяются вручную в backend/.gitlab-ci.yaml и frontend/.gitlab-ci.yaml через переменную VERSION
- Патч-версии приложения изменяются автоматически на основе переменной CI_PIPELINE_ID.
- Версия приложения в чарте меняется вручную

# Инфраструктура
- Код хранится в [gitlab](https://gitlab.praktikum-services.ru/std-032-63/momo-store)
- Образы docker в [gitlab container registry](https://gitlab.praktikum-services.ru/std-032-63/momo-store/container_registry)
- Helm-чарты в [nexus](http://nexus.praktikum-services.tech/repository/momo-store-helm-std-032-63/)
- K8s кластер в [yandex managed service for kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)
- Terraform state и статика фронтенда в [yandex object storage](https://yandex.cloud/ru/services/storage)
- Мониторинг приложения можно выполнять с помощью просмотра метрик через prometheus, в планах настроить графики в grafana.
- Логирование приложения планируется выполнять с помощью loki-stack и выводить в grafana, в разработке.

### В директориях infra/helm и infra/terraform находится дополнительная информация по развертыванию инфраструктуры и приложения.

# Запуск приложения локально
## Docker 
```bash
#build&run
docker network create momo-store-net && \
docker build -t momo-store-backend-1 -f backend/Dockerfile . && \
docker run -d --rm -p 8081:8081 --network momo-store-net --name momo-store-backend-1 momo-store-backend-1 && \
docker build -t momo-store-frontend-1 -f frontend/Dockerfile . && \
docker run -d --rm -p 8080:8080 --network momo-store-net --name momo-store-frontend-1 momo-store-frontend-1
#see result at http://localhost:8080
```
```bash
#stop&cleanup
docker stop momo-store-backend-1 momo-store-frontend-1 && \
docker network remove momo-store-net
```
## Docker Compose
```bash
#build&run
docker compose up -d
#see result at http://localhost:8080
```
```bash
#stop&cleanup
docker compose down
```