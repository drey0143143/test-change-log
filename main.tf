resource "aws_iam_role" "orchestration_role1" {
  name = local.orchestration_role_name

  assume_role_policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Principal":{
      "Federated": "arn:aws:iam::${var.aws_oidc_account}:oidc-provider/token.actions.githubusercontent.com"
    },
    "Condition":{
      "StringEquals":{
        "token.actions.githubusercontent.com:sub": [
          "repo:ipipeline/${var.github_repo_name}:ref:refs/heads/working-test",
          "repo:ipipeline/${var.github_repo_name}:push"
        ]
      }
    }
  }
}
EOF
  tags               = var.tags
}


variable "github_repo_name" {
  description = "The name of the repository to use with assume role policy trust condition"
  type        = list(string)
}

variable "orchestration_policy_name_prefix" {
  default     = ""
  description = "The name of policy to be attached to orchestration role created. Preceds suffix of same type."
  type        = string
}

variable "orchestration_policy_name_suffix" {
  default     = "_orchestration_role_policy"
  description = "The name of policy to be attached to orchestration role created. Appended to prefix of same type."
  type        = list
}

