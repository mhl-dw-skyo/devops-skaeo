resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  namespace  = "kube-system"
  version    = "1.2.1"
  dynamic "set" {
    for_each = {
      "settings.clusterName"                                               = local.eks_cluster_name
      "settings.clusterEndpoint"                                           = data.aws_eks_cluster.eks.endpoint
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"          = module.eks_irsa_karpenter_controller.arn
      "controller.metrics.enabled"                                         = "true"
      "controller.metrics.port"                                            =  8080
      "webhook.enabled"                                                    = "false"
      "replicas"                                                           = 2
      "nodeSelector.group"                                                 = "default_node_group"
    }
    content {
      name  = set.key
      value = set.value
    }
  }
  values = [
    <<EOF
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - topologyKey: "kubernetes.io/hostname"
EOF
  ]
}
