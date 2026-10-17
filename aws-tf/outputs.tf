output "instance_ips" {
  description = "IP of the created EC2 instance"
  value = {
    public_ip = aws_instance.myServer.public_ip
    private_ip = aws_instance.myServer.private_ip
  }
}

output "instance_subnet_id" {
  value = aws_instance.myServer.subnet_id
}