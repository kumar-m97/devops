output "ec2_public_ip" {
    description = "pulic ip of ec2 instance"
    value       = aws_instance.instance1.public_ip
}