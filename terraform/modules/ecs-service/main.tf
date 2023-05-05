resource "aws_ecs_service" "ecs_service" {
  name            = var.aws_ecs_service_name        # Naming our first service
  cluster         = var.aws_ecs_cluster_id          # Referencing our created Cluster
  task_definition = var.aws_ecs_task_definition_arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 4 # Setting the number of containers we want deployed to 3

  load_balancer {
    target_group_arn = var.aws_ecs_service_lb_target_group_arn # Referencing our target group
    container_name   = var.aws_ecs_service_lb_task_definition_family
    container_port   = var.aws_ecs_service_lb_task_container_port # Specifying the container port
  }

  network_configuration {
    subnets          = var.aws_ecs_service_network_configuration_subnets
    assign_public_ip = true                                                    # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.ecs_service_security_group.id}"] # Setting the security group
  }
}

# Creating a security group for the load balancer:
resource "aws_security_group" "ecs_service_security_group" {
  name        = var.aws_ecs_sg_name
  description = var.aws_ecs_sg_description

  dynamic "ingress" {
    for_each = var.aws_ecs_sg_ingress_rules
    content {
      description     = lookup(ingress.value, "description", null)
      from_port       = lookup(ingress.value, "from_port", null)
      to_port         = lookup(ingress.value, "to_port", null)
      protocol        = lookup(ingress.value, "protocol", null)
      security_groups = lookup(ingress.value, "security_groups", null)
    }
  }

  dynamic "egress" {
    for_each = var.aws_ecs_sg_egress_rules
    content {
      description = lookup(egress.value, "description", null)
      from_port   = lookup(egress.value, "from_port", null)
      to_port     = lookup(egress.value, "to_port", null)
      protocol    = lookup(egress.value, "protocol", null)
      cidr_blocks = lookup(egress.value, "cidr_blocks", null)
    }
  }
}
