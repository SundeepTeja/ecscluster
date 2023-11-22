resource "aws_iam_policy" "policy" {
  name        = "${local.name_prefix}-policy"
  path        = "/"
  description = "${local.name_prefix}-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "arn:aws:lambda:*:*:function:Automation*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateImage",
                "ec2:CopyImage",
                "ec2:DeregisterImage",
                "ec2:DescribeImages",
                "ec2:DeleteSnapshot",
                "ec2:StartInstances",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeTags",
                "cloudformation:CreateStack",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "ec2:*",
                "ecs:*",
                "ecr:*",
                "autoscaling:*",
                "elasticloadbalancing:*",
                "application-autoscaling:*",
                "cloudwatch:*",
                "logs:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
         "Action": "ssm:GetParameters",
         "Effect": "Allow",
         "Resource": "arn:aws:ssm:${local.region_name}:${local.account_id}:parameter/CodeBuild/*"
        },
         {
            "Action": "secretsmanager:GetSecretValue",
            "Effect": "Allow",
            "Resource": "arn:aws:secretsmanager:${local.region_name}:${local.account_id}:secret:*"
        },
        {
              "Sid": "GrantKMSRead",
              "Effect": "Allow",
              "Action": [
                "kms:GetParametersForImport",
                "kms:DescribeCustomKeyStores",
                "kms:ListKeys",
                "kms:GetPublicKey",
                "kms:ListKeyPolicies",
                "kms:ListRetirableGrants",
                "kms:GetKeyRotationStatus",
                "kms:ListAliases",
                "kms:GetKeyPolicy",
                "kms:DescribeKey",
                "kms:ListResourceTags",
                "kms:ListGrants",
	        	"kms:Encrypt",
	        	"kms:Decrypt"
               ],
               "Resource": [
                   "*"
               ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "arn:aws:sns:*:*:Automation*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "arn:aws:lambda:*:*:function:SSM*",
                "arn:aws:lambda:*:*:function:*:SSM*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:StartExecution"
            ],
            "Resource": [
                "arn:aws:states:*:*:stateMachine:SSM*",
                "arn:aws:states:*:*:execution:SSM*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "resource-groups:ListGroups",
                "resource-groups:ListGroupResources"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "tag:GetResources"
            ],
            "Resource": [
                "*"
            ]
        }
   ]
 }
EOF
}

resource "aws_iam_role" "role" {
  name = "${local.name_prefix}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": { 
        "Service": [
          "ec2.amazonaws.com", 
          "ssm.amazonaws.com",
          "ecs.amazonaws.com",
          "ecs-tasks.amazonaws.com",
          "batch.amazonaws.com",
          "secretsmanager.amazonaws.com"
         ]
          },
      "Effect": "Allow",
      "Sid": "SSMAssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
    role       = aws_iam_role.role.name
    policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "${local.name_prefix}-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "${local.name_prefix}-ssm-iam-policy"
  role = aws_iam_role.role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
              "Sid": "GrantsAccessToIAMRoles",
              "Effect": "Allow",
              "Action": [
                 "iam:*"
               ],
               "Resource": [
                   "${aws_iam_role.role.arn}",
                   "${aws_iam_role.role.arn}/*"
               ]
    },
    {
              "Sid": "GrantSTS",
              "Effect": "Allow",
              "Action": [
                 "sts:AssumeRole"
               ],
               "Resource": [
                   "${aws_iam_role.role.arn}",
                   "${aws_iam_role.role.arn}/*"
               ]
    }  
  ]
}
EOF
}