resource "kubernetes_manifest" "nodepool" {
  count = var.enable_karpenter ? 1 : 0     
  computed_fields = ["spec.template", "spec.spec", "spec.disruption"]
  manifest  = yamldecode(<<-EOF
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: ${local.common_nodepool_name}
    spec:
      template:
        metadata:
          labels:
            group: ${local.common_nodepool_name}
            managed-by: karpenter
        spec:
          requirements:
            - key: "karpenter.sh/capacity-type"
              operator: In
              values: ["spot"]
            - key: "kubernetes.io/arch"
              operator: In
              values: ["arm64"]
            - key: "node.kubernetes.io/instance-type"
              operator: In
              values: [${join(",", var.instance_types_karpenter)}]
          taints:
            - key: "group"
              value: "common"
              effect: "NoSchedule"
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
