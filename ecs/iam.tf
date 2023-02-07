resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project}-ecs-task-execution"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    Name = "${var.project}-ecs-task-execution"
  }
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = data.aws_iam_policy.ecs_task_execution.arn
}

# enable ecs to access to secret manager
resource "aws_iam_policy" "config_access" {
  name = "${var.project}-sm"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetSecretValue",
            "kms:Decrypt"
          ],
          "Resource" : [
            "arn:aws:secretsmanager:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:secret:${var.control_plane_config_secret}",
            "arn:aws:secretsmanager:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:secret:${var.envoy_config_secret}",
            "arn:aws:secretsmanager:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:secret:${var.encryption_key_secret}",
            "arn:aws:kms:${data.aws_region.current.id}:${data.aws_caller_identity.self.account_id}:key/${var.kms_decryption_key_id}"
          ]
        },
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_config_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.config_access.arn
}

# enable ecs to access filestore 
resource "aws_iam_policy" "filestore_access" {
  name = "${var.project}-s3-filestore"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "s3:*"
          "Resource" : "arn:aws:s3:::${var.filestore_bucket_name}/*"
        },
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_filestore_access" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.filestore_access.arn
}

# for ECS exec
resource "aws_iam_role" "ecs_task" {
  name = "${var.project}-ecs-task"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = {
    Name = "${var.project}-ecs-task"
  }
}

resource "aws_iam_role_policy" "ecs_task_ssm" {
  name = "${var.project}-ssm"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}