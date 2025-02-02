resource "yandex_vpc_network" "momo_network" {
  name        = "${var.cluster_name}-network"
  description = "Shared network for momo-store"
}

resource "yandex_vpc_subnet" "momo_subnet" {
  name           = "${var.cluster_name}-subnet"
  description    = "Subnet for momo-store"
  zone           = var.zone
  network_id     = yandex_vpc_network.momo_network.id
  v4_cidr_blocks = ["10.0.0.0/16"]
}

resource "yandex_vpc_security_group" "k8s-public-services" {
  name        = "${var.cluster_name}-k8s-public-services"
  description = "Security group rules allow connections from the internet to services. Apply these rules only to node groups."
  network_id  = yandex_vpc_network.momo_network.id

  ingress {
    protocol       = "TCP"
    description    = "This rule allows incoming traffic from the internet to the NodePort range. Add or modify ports as needed."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

resource "yandex_vpc_security_group" "k8s-main-sg" {
  name        = "${var.cluster_name}-k8s-main-sg"
  description = "Security group rules ensure basic cluster functionality. Apply to both the cluster and node groups."
  network_id  = yandex_vpc_network.momo_network.id

  ingress {
    protocol          = "TCP"
    description       = "This rule allows health checks from the load balancer address range. Required for high-availability clusters and load balancer services."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "ANY"
    description       = "This rule allows communication between master and node within the security group."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol       = "ANY"
    description    = "This rule allows pod-to-pod and service-to-service communication. Specify the subnets for your cluster and services."
    v4_cidr_blocks = ["10.0.0.0/16"]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "ICMP"
    description    = "This rule allows debugging ICMP packets from internal subnets."
    v4_cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8", "192.168.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    description    = "This rule allows all outbound traffic. Nodes can connect to Yandex Container Registry, Object Storage, Docker Hub, etc."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}