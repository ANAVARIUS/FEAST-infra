# =========================
# ECS CLUSTER
# =========================
resource "aws_ecs_cluster" "main" {
  name = "feast-${var.environment}-cluster"
}

# =========================
# SECURITY GROUP
# =========================
resource "aws_security_group" "ecs_sg" {
  name   = "feast-ecs-sg"
  vpc_id = var.vpc_id

  # Permitir tráfico HTTP (para demo)
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida libre
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =========================
# TASK DEFINITION
# =========================
resource "aws_ecs_task_definition" "app" {
  family                   = "feast-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.container_image

      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}

# =========================
# ECS SERVICE
# =========================
resource "aws_ecs_service" "app" {
  name            = "feast-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets         = [var.subnet_id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

load_balancer {
  target_group_arn = var.target_group_arn
  container_name   = "app"
  container_port   = 8000
}