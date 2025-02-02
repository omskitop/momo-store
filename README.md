# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

## Frontend

```bash
npm install
NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run serve
```

## Backend

```bash
go run ./cmd/api
go test -v ./... 
```

# Docker build&run

### Backend
```bash
cd backend
docker build -t backend .
docker run -p 8081:8081 backend
```
### Frontend
```bash
cd frontend
docker build -t frontend .
docker run -p 8080:8080 -e NODE_ENV=production -e VUE_APP_API_URL=http://localhost:8081 frontend
```

# K8S cluster creation

Deployment of the Kubernetes cluster is performed using Terraform via CI/CD. The `deploy` job is triggered manually. The state of all Terraform objects is stored in S3.

### Dependencies

- **Terraform**: `version >= 1.5.7`
- **Yandex Cloud Provider**: `version >= 0.87.0`
- **Gitlab**: `16.11.10 <= version < 18.0`
- **kubectl**: `version = 1.29.0`

### Gitlab CI/CD Variables:

`YC_KEY` - Static access key for the Yandex Cloud service account. The service account must be created in advance in the Yandex Cloud console and granted admin rights for the folder where the k8s cluster is planned to be deployed. The key can be obtained using the command:

```bash
yc iam key create --service-account-name <name> --output key.json
```

`YC_CLOUD_ID` - The ID of the cloud where the cluster will be created.

`YC_FOLDER_ID` - The ID of the folder where the cluster will be created.

`YC_BUCKET_ACCESS_KEY` - Access key for the S3 bucket where Terraform states will be stored. The bucket must be created via the Yandex Cloud console, and access must be granted to the service account.

`YC_BUCKET_SECRET_KEY` - Secret access key for the S3 bucket.

`CLUSTER_NAME` - The name of the cluster.

### Output

After successful cluster creation, the following data is output:

`Cluster_IP_Adress` - External IP address of the cluster.

`Cluster_ID` - Unique ID of the cluster.

`Cluster_Name` - Name of the cluster.

### Cluster connection

After creating the cluster, connect to it using the command:

```bash
yc managed-kubernetes cluster get-credentials <cluster_name_or_id> --external
```

Next, verify that the configuration is correct:

```bash
kubectl cluster-info
```

### Cluster deletion

To delete the cluster and all dependent resources, manually trigger the `cleanup` job.