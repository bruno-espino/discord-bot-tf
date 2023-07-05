output "ssh_string"{
    value = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.bot.public_ip}"
}