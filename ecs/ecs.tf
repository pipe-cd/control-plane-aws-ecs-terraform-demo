resource "aws_ecs_cluster" "this" {
  name = var.project

  tags = {
    Name = "${var.project}"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT",
  ]
}

resource "aws_ecs_task_definition" "this" {
  family        = var.project
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
        name  = "pipecd-gateway"
        image = var.gateway_image_url
        portMappings = [
          {
            hostPort      = 9090
            containerPort = 9090
            protocol      = "tcp"
          }
        ]
        essential = false
        command = [
          "/bin/sh -c 'echo $ENVOY_CONFIG; echo $ENVOY_CONFIG | base64 -d >> envoy-config.yaml; envoy -c envoy-config.yaml;'"
        ]
        entrypoint = [
          "sh",
          "-c"
        ]
        secrets = [
          {
            "name" : "ENVOY_CONFIG",
            "valueFrom" : "${data.aws_secretsmanager_secret.envoy_config.arn}"
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.log_group_name
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "${var.project}-pipecd-gateway"
          }
        }
      },
      {
        name  = "pipecd-server"
        image = var.server_image_url
        portMappings = [
        ]
        command = [
          "/bin/sh -c 'echo $CONTROL_PLANE_CONFIG; echo $CONTROL_PLANE_CONFIG | base64 -d >> control-plane-config.yaml; sed -i -e s/pipecd-mysql/${var.db_instance_address}/ control-plane-config.yaml; echo $ENCRYPTION_KEY >> encryption-key; pipecd server --insecure-cookie=true --cache-address=${var.redis_host}:6379 --config-file=control-plane-config.yaml --enable-grpc-reflection=false --encryption-key-file=encryption-key --log-encoding=humanize --metrics=true;'"
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
            awslogs-stream-prefix = "${var.project}-pipecd-server"
          }
        }
      },
    ]
  )
  tags = {
    Name = "${var.project}"
  }
}
resource "aws_ecs_service" "this" {
  name    = var.project
  cluster = aws_ecs_cluster.this.arn
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }
  platform_version                   = "1.4.0"
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  depends_on                         = [aws_iam_role.ecs_task_execution]
  dynamic "load_balancer" {
    for_each = [var.lb_target_group_arn_http, var.lb_target_group_arn_grpc]
    content {
      container_name   = "pipecd-gateway"
      container_port   = 9090
      target_group_arn = load_balancer.value
    }
  }
  health_check_grace_period_seconds = 60
  network_configuration {
    security_groups = [
      aws_security_group.server.id
    ]
    subnets = [
      var.subnet_id
    ]
  }
  enable_execute_command = true
  tags = {
    Name = "${var.project}"
  }
}