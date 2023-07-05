resource "aws_iam_role" "bot_role" {
  name = "bot_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

}
resource "aws_iam_instance_profile" "bot_profile" {
  name = "bot-profile"
  role = aws_iam_role.bot_role.name
}

resource "aws_security_group" "bot_sg" {
  name        = "bot_sg"
  description = "bot security group"
  vpc_id      = aws_vpc.bot_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "bot" {
  ami                    = data.aws_ami.AL3.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bot_sg.id]
  subnet_id              = aws_subnet.bot_subnet.id
  iam_instance_profile   = aws_iam_instance_profile.bot_profile.id
  key_name               = var.key_name
  lifecycle {
    ignore_changes = [ami]
  }
  user_data = file("userdata.tpl")
  user_data_replace_on_change = true
  tags = {
    Name = "botardo"
  }
}