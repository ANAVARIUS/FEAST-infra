# =========================
# SECURITY GROUP (ALB)
# =========================
resource "aws_security_group" "alb_sg" {
  name   = "feast-alb-sg"
  vpc_id = var.vpc_id

  # Permitir tráfico HTTP desde internet
  ingress {
    from_port   = 80
    to_port     = 80
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
# LOAD BALANCER
# =========================
resource "aws_lb" "main" {
  name               = "feast-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.subnet_id]

  security_groups = [aws_security_group.alb_sg.id]
}

# =========================
# TARGET GROUP
# =========================
resource "aws_lb_target_group" "main" {
  name     = "feast-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"
}

# =========================
# LISTENER
# =========================
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}