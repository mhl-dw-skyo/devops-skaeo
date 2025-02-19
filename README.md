https://app.eraser.io/workspace/1hdVVwm1vkQpOlSlCduH?origin=share

![diagram-export-19-02-2025-09_53_19](https://github.com/user-attachments/assets/444982d3-9d5c-49c5-b3df-5718f7928406)


# High-Level Overview of EKS Cluster Configuration
## Traffic Management (Ingress)
- **Load Balancer**: Routes incoming traffic to the appropriate service based on the host and path specified in the ingress file configuration.
- **Service Discovery**: Uses labels to discover and forward traffic to the appropriate pods.
## Monitoring and Metrics
- **Prometheus and Grafana**: Installed on the EKS cluster to gather and visualize metrics for pods, nodes, and the cluster as a whole.
- **KEDA**: Integrates with Prometheus to fetch metrics and automatically scale pods based on CPU and memory usage.
## Logging
- **ELK Stack**: Comprises Elasticsearch, Kibana, and Fluentbit to manage and visualize container logs effectively.
- Or **Loki**
## Autoscaling
- **Karpenter**: Utilized to dynamically scale EC2 nodes within the EKS cluster to accommodate varying loads.
## Security and Resource Access
- **IRSA (IAM Role with Service Account)**: Ensures pods can securely access external resources like S3 and Secret Manager.
## Internal Communication
- **Pod Communication**: Pods communicate internally using service names, facilitating seamless interaction within the cluster.

