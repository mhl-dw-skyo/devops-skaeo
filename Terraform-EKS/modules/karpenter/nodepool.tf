resource "kubernetes_manifest" "nodepool" {
  for_each = var.enable_karpenter ? var.nodepool_configs : {}     
  computed_fields = ["spec.template", "spec.spec", "spec.disruption"]
  manifest  = yamldecode(<<-EOF
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: ${each.value.name}
    spec:
      template:
        metadata:
          labels:
            group: ${each.value.name}
            managed-by: karpenter
        spec:
          requirements:
            - key: "karpenter.sh/capacity-type"
              operator: In
              values: [${join(",", each.value.capacity_type)}]
            - key: "kubernetes.io/arch"
              operator: In
              values: [${join(",", each.value.arch)}]
            - key: "node.kubernetes.io/instance-type"
              operator: In
              values: [${join(",", each.value.instance_types_karpenter)}]
          %{ if try(each.value.taint, null) != null }
          taints:
            - key: ${each.value.taint["key"]}
              value: ${each.value.taint["value"]}
              effect: ${each.value.taint["effect"]}
          %{ endif }
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: ${local.common_nodeclass_name}
          expireAfter: 720h
      disruption:
        consolidationPolicy: WhenEmptyOrUnderutilized
        consolidateAfter: 100s
        budgets:
        - nodes: 50%
        # If enabled, Disruption will be disabled during the following times
        # excludedTimes:
        #   - start: "0 23 * * 1-5"  # Start at 11:00 PM, Monday to Friday
        #     end: "0 5 * * 2-6"     # End at 5:00 AM, Tuesday to Saturday
   EOF
  )
  depends_on = [ helm_release.karpenter ]
}


resource "kubernetes_manifest" "ec2nodeclass" {
  count = var.enable_karpenter ? 1 : 0
  manifest = {
    apiVersion = "karpenter.k8s.aws/v1"
    kind       = "EC2NodeClass"
    metadata = {
      name = "${local.common_nodeclass_name}"
    }
    spec = {
      instanceProfile = "${aws_iam_instance_profile.karpenter_node_profile.name}"
      subnetSelectorTerms = [{
        tags = {
          "karpenter.sh/discovery" = local.eks_cluster_name
        }
      }]
      securityGroupSelectorTerms = [{
        tags = {
          "karpenter.sh/discovery" = local.eks_cluster_name
        }
      }]
      metadataOptions = {
        httpEndpoint = "enabled"
        httpTokens = "optional"
      }
      amiFamily = "AL2"
      amiSelectorTerms = [{
        alias = "al2@latest"
      }]
      tags = {
        "managed-by" = "karpenter"
        "pool"       = "${local.common_nodepool_name}"
      }
    }
  }
  depends_on = [ helm_release.karpenter ]
}



