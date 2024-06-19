resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster-example"
}

resource "aws_ecr_repository" "ecs_registry" {
  name = "example-${terraform.workspace}-registry-next"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx-example"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "959936929933.dkr.ecr.us-east-1.amazonaws.com/example-default-registry-next:latest"
      cpu       = 256
      memory    = 512
      essential = true
      interactive = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      secrets = [
        {
          name      = "NEXT_PUBLIC_NEXT_ENV"
          valueFrom = "arn:aws:secretsmanager:us-east-1:959936929933:secret:next/develop-7NlCU8:NEXT_PUBLIC_NEXT_ENV::"
        }
    ]
    logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.default.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "nginx"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/ecs/nginx"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_ecr_policy" {
  name   = "ecs_ecr_policy"
  role   = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "ecr:*",
          "secretsmanager:*",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:CreateControlChannel",
          "logs:*"
        ]
        Resource  = "*"
      }
    ]
  })
}

resource "aws_ecs_service" "next_service" {
  name            = "next-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets         = module.vpc.public_subnets
    assign_public_ip = true
    security_groups = [aws_security_group.sg.id]
  }
}

resource "aws_security_group" "sg" {
  name        = "ecs_service_sg"
  description = "Allow inbound access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}