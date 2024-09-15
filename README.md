# AWS Containers Qualgo Lab Sample
        |
## Quickstart

The following sections provide quickstart instructions for various platforms. All of these assume that you have cloned this repository locally and are using a CLI thats current directory is the root of the code repository.

### Docker Compose

This deployment method will run the application on your local machine using `tilt`, and will build the containers as part of the deployment.

Pre-requisites:

- Docker installed locally
- Tilt installed locally: https://docs.tilt.dev/install

Change directory to the Docker Compose deploy directory:

```
cd deploy/docker-compose
```

Use `tilt` to run the application containers:

```
tilt up
```

Open the frontend in a browser window:

```
http://localhost:3001
```

To stop the containers in `docker` use Ctrl+C. To delete all the containers and related resources run:

```
tilt down
```
### Kubernetes Local

This deployment method will run the application in an existing Kubernetes cluster.

Pre-requisites:

- Kubernetes cluster: https://docs.k3s.io/installation
- `kubectl` installed locally
- Tilt installed locally: https://docs.tilt.dev/install
- Helm
- helmfile


Change directory to the Docker Compose deploy directory:

```
cd deploy/kubernetes
```

Use `tilt` to run the application Kubernetes:

```
tilt up
```

Open the frontend in a browser window:

```
http://localhost:8080
```

To stop the containers in `Kubernetes` use Ctrl+C. To delete all the containers and related resources run:

```
tilt down
```
### AWS Kubernetes (EKS) 
This deployment method will run the application onAWS.

Pre-requisites:

- AWS CLI
- Terraform
- `kubectl` installed locally
Change directory to the Terraform provision IaC deploy directory:

```
cd deploy/terraform/eks/default
```

```shell
terraform init
terraform plan
terraform apply
```
