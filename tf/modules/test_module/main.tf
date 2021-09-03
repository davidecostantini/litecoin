resource "aws_iam_role" "aws_role" {
  name                  = "role_${var.entity_name}"
  assume_role_policy    = data.aws_iam_policy_document.role_policy.json
  tags                  = { provisioned = "tf" }
}


data "aws_iam_policy_document" "role_policy" {
  statement {
    actions       = ["sts:AssumeRole"]
    effect   	  = "Allow"

    principals {
      type        = "AWS"
      identifiers = [
	"arn:aws:iam::${var.account_id}:root"
      ]
    }
  }
}

resource "aws_iam_policy" "aws_assum_role_policy" {
  name        = "assume_role_${var.entity_name}"
  description = "Users policy to assume role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole*",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::${var.account_id}:role/${aws_iam_role.aws_role.name}"
      },
    ]
  })
  tags = { provisioned = "tf" }
}

resource "aws_iam_group" "aws_group" {
  name 	     = "group_${var.entity_name}"
}

resource "aws_iam_group_policy_attachment" "aws_group_pol_attach" {
  group      = aws_iam_group.aws_group.id
  policy_arn = aws_iam_policy.aws_assum_role_policy.id
}
