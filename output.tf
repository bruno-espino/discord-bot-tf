output "ssh_string"{
    value = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.bot.public_ip}"
}