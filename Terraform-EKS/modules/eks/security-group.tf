resource "aws_security_group" "cluster"{
    name = "${local.eks_cluster_name}-security-group"
    vpc_id =  data.aws_vpc.selected.id
    tags   = merge(local.tags,local.sg-tags)
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each          = var.sg_ingress_rules
  type              = "ingress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.proto
  cidr_blocks       = [each.value.cidr]

  description       = each.value.desc
  security_group_id = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "ingress_rules_sg" {
  for_each          = var.sg_ingress_rules_source
  type              = "ingress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.proto
  source_security_group_id   = each.value.source_security_group_id
  description       = each.value.desc
  security_group_id = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "egress_rules" {
  for_each          = var.sg_egress_rules
  type              = "egress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.proto
  cidr_blocks       = [each.value.cidr]
  description       = each.value.desc
  security_group_id = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "egress_rules_sg" {
  for_each          = var.sg_egress_rules_source
  type              = "egress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.proto
  source_security_group_id    = each.value.source_security_group_id
  description       = each.value.desc
  security_group_id = aws_security_group.cluster.id
}


