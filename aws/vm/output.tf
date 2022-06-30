output "web_instance_ip" {
    value = aws_instance.web.*.private_ip
}
output "web_instance_dns" {
    value = aws_instance.web.*.private_dns
}
output "haproxy_instance_dns" {
    value = aws_instance.haproxy.*.public_dns
}
output "haproxy_instance_ip" {
    value = aws_instance.haproxy.*.public_ip
}

