data "aws_caller_identity" "current" {}

provider "aws" {
  region = "eu-west-1"
}

#
# Module to create common resources
#

module "test1" {
  source      = "./modules/test_module"
  account_id  = data.aws_caller_identity.current.account_id
  entity_name = "test1"
}

#
# Creating users and adding to group
#
resource "aws_iam_group_membership" "group_devs" {
  name = "developers"

  users = [
    aws_iam_user.user_one.name,
  ]

  group = module.test1.group_name
}

resource "aws_iam_user" "user_one" {
  name = "user-one"
}
