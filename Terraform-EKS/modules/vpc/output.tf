
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_sub_ids" {
  value = aws_subnet.private.*.id
}

output "public_sub_ids" {
  value = aws_subnet.public.*.id
}
