resource "aws_ecs_task_definition" "ops" {
  family        = "${var.project}-ops"
  task_role_arn = aws_iam_role.ecs_task.arn
  network_mode  = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  memory             = var.memory
  cpu                = var.cpu
  container_definitions = jsonencode(
    [
      {
        name  = "pipecd-ops"
        image = var.ops_image_url
        portMappings = [
          {
            "name" : "http",
            "protocol" : "tcp",
            "containerPort" : 9082,
            "appProtocol" : "http"
          },
          {
            "name" : "http",
            "protocol" : "tcp",
            "containerPort" : 9085,
            "appProtocol" : "http"
          },
        ]
        command = [
          "/bin/sh -c 'echo $CONTROL_PLANE_CONFIG; echo $CONTROL_PLANE_CONFIG | base64 -d >> control-plane-config.yaml; sed -i -e s/pipecd-mysql/${var.db_instance_address}/ control-plane-config.yaml; echo $ENCRYPTION_KEY >> encryption-key; pipecd ops --cache-address=${var.redis_host}:6379 --config-file=control-plane-config.yaml --log-encoding=humanize --metrics=true;'"
        ]
        entrypoint = [
          "sh",
          "-c"
        ]
        secrets = [
          {
            "name" : "ENCRYPTION_KEY",
            "valueFrom" : "${data.aws_secretsmanager_secret.encryption_key.arn}"
          },
          {
            "name" : "CONTROL_PLANE_CONFIG",
            "valueFrom" : "${data.aws_secretsmanager_secret.control_plane_config.arn}"
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.log_group_name
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "${var.project}-pipecd-ops"
          }
        }
      },
    ]
  )
  tags = {
    Name = "${var.project}"
  }
}
resource "aws_ecs_service" "ops" {
  name    = "${var.project}-ops"
  cluster = aws_ecs_cluster.this.arn
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }
  platform_version                   = "1.4.0"
  task_definition                    = aws_ecs_task_definition.ops.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  depends_on                         = [aws_iam_role.ecs_task_execution]
  # health_check_grace_period_seconds = 60
  network_configuration {
    security_groups = [
      aws_security_group.ops.id
    ]
    subnets = [
      var.subnet_id
    ]
  }
  enable_execute_command = true
  # load_balancer {
  #   container_name   = "pipecd-server"
  #   container_port   = 9090
  #   target_group_arn = var.lb_target_group_arn
  # }
  tags = {
    Name = "${var.project}"
  }
}