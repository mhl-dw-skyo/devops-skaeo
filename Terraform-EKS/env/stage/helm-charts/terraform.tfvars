env        = "stage-eu"
aws_region = "eu-central-1"



enable_karpenter = true


nodepool_configs = {
    nodepool1 = {
    name          = "common-group"
    taint         = {key = "group", value = "common", effect = "NoSchedule"}
    instance_types_karpenter = ["t4g.medium", "c6g.xlarge", "c6g.2xlarge"]
    capacity_type  = ["spot"]
    arch          = ["arm64"]
    
  },
    nodepool2 = {
    name          = "stage-group"
    #taint         = null
    taint         = {key = "group", value = "stage", effect = "NoSchedule"}
    instance_types_karpenter = ["t4g.medium", "c6g.xlarge", "c6g.2xlarge"]
    capacity_type  = ["spot"]
    arch          = ["arm64"]
    
  
    
  }
}

ecr_repo_names = ["myrollcallpro-web-staging","myrollcallpro-website-staging","myrollcallpro-staging","myrollcallpro-attendance-staging"]