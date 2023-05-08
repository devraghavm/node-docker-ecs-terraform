resource "aws_alb" "application_load_balancer" {
  name               = var.aws_alb_name # Naming our load balancer
  load_balancer_type = "application"
  subnets            = var.aws_default_subnets
  # Referencing the security group
  security_groups = ["${var.aws_alb_sg_id}"]
}

resource "aws_lb_target_group" "target_group" {
  name        = var.aws_alb_tg_name
  port        = var.aws_alb_tg_port
  protocol    = var.aws_alb_tg_protocol
  target_type = var.aws_alb_tg_target_type
  vpc_id      = var.aws_alb_vpc_id # Referencing the default VPC
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn # Referencing our load balancer
  port              = var.aws_alb_listener_port
  protocol          = var.aws_alb_listener_protocol
  default_action {
    type             = var.aws_alb_listener_default_action_type
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our tagrte group
  }
}
