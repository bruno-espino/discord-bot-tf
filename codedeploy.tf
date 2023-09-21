resource "aws_iam_role" "code_deploy_role" {
  name = "code_deploy_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "codedeploy.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"]
}


resource "aws_codedeploy_app" "bot_app" {
  compute_platform = "Server"
  name             = "bot-app"
}


resource "aws_codedeploy_deployment_group" "bot_deploy" {
  app_name              = aws_codedeploy_app.bot_app.name
  deployment_group_name = "bot-deploy-group"
  service_role_arn      = aws_iam_role.code_deploy_role.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "botardo"
    }
  }

  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }
}