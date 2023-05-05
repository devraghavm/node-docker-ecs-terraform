variable "aws_ecs_service_name" {
  description = "AWS ECS Service Name"
  type        = string
}

variable "aws_ecs_cluster_id" {
  description = "AWS ECS Cluster ID"
  type        = string
}

variable "aws_ecs_task_definition_arn" {
  description = "AWS ECS Task Definition ARN"
  type        = string
}

variable "aws_ecs_service_network_configuration_subnets" {
  description = "AWS ECS Service Network Configuration Subnets"
  type        = list(string)
}

variable "aws_ecs_service_lb_target_group_arn" {
  description = "AWS ECS Service Load Balancer Target Group ARN"
  type        = string
}

variable "aws_ecs_service_lb_task_definition_family" {
  description = "AWS ECS Task Definition Family"
  type        = string
}

variable "aws_ecs_service_lb_task_container_port" {
  description = "AWS ECS Task Container Port"
  type        = number
}

variable "aws_ecs_sg_name" {
  description = "AWS ECS SG Name"
  type        = string
}

variable "aws_ecs_sg_description" {
  description = "AWS ECS SG Description"
  type        = string
}


variable "aws_ecs_sg_ingress_rules" {
  description = "AWS ECS SG Ingress Rules"
  type = map(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
}

variable "aws_ecs_sg_egress_rules" {
  description = "AWS ECS SG egress Rules"
  type = map(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
}
