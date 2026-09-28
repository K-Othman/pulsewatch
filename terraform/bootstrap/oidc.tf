# Registers GitHub as a trusted identity provider in this AWS account,
# so pipeline runs can prove who they are without stored AWS keys.


resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}