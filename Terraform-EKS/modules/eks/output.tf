output "private_key" {
    value = tls_private_key.ec2_private_key.private_key_pem
    sensitive = true
}