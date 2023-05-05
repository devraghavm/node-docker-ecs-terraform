module "archive_ecr_repository" {
  source                  = "./modules/ecr"
  aws_ecr_repository_name = var.archive_ecr_repository_name
}

module "archive_ecs_cluster" {
  source               = "./modules/ecs"
  aws_ecs_cluster_name = var.archive_ecs_cluster_name
}

module "archive_iam" {
  source                               = "./modules/iam"
  aws_ecs_task_execution_iam_role_name = var.archive_ecs_task_execution_iam_role_name
}

module "archive_ecs_task_definition" {
  source                              = "./modules/ecs-task-definition"
  aws_ecs_task_name                   = var.archive_ecs_task_name
  aws_ecr_repository_url              = module.archive_ecr_repository.aws_ecr_repository_url
  aws_ecs_task_container_port         = var.aws_ecs_task_container_port
  aws_ecs_task_host_port              = var.aws_ecs_task_host_port
  aws_ecs_task_memory                 = var.aws_ecs_task_memory
  aws_ecs_task_cpu                    = var.aws_ecs_task_cpu
  aws_ecs_task_execution_iam_role_arn = module.archive_iam.aws_ecs_iam_execution_role_arn
  depends_on                          = [module.archive_ecr_repository, module.archive_ecs_cluster, module.archive_iam]
}


module "archive_vpc" {
  source = "./modules/vpc"
}

module "archive_ec2" {
  source                               = "./modules/ec2"
  aws_alb_name                         = var.aws_alb_name
  aws_sg_name                          = var.aws_sg_name
  aws_sg_description                   = var.aws_sg_description
  aws_default_subnets                  = ["${module.archive_vpc.aws_default_subnet_a_id}", "${module.archive_vpc.aws_default_subnet_b_id}", "${module.archive_vpc.aws_default_subnet_c_id}", "${module.archive_vpc.aws_default_subnet_d_id}"]
  aws_sg_ingress_rules                 = var.archive_sg_ingress_rules
  aws_sg_egress_rules                  = var.archive_sg_egress_rules
  aws_alb_tg_name                      = var.archive_alb_tg_name
  aws_alb_tg_port                      = var.archive_alb_tg_port
  aws_alb_tg_protocol                  = var.archive_alb_tg_protocol
  aws_alb_tg_target_type               = var.archive_alb_tg_target_type
  aws_alb_vpc_id                       = module.archive_vpc.aws_default_vpc_id
  aws_alb_listener_port                = var.archive_alb_listener_port
  aws_alb_listener_protocol            = var.archive_alb_listener_protocol
  aws_alb_listener_default_action_type = var.archive_alb_listener_default_action_type
  depends_on                           = [module.archive_vpc]
}

module "archive_ecs_service" {
  source                                        = "./modules/ecs-service"
  aws_ecs_service_name                          = var.archive_ecs_service_name
  aws_ecs_cluster_id                            = module.archive_ecs_cluster.aws_ecs_cluster_id
  aws_ecs_task_definition_arn                   = module.archive_ecs_task_definition.aws_ecs_task_definition_task_arn
  aws_ecs_service_lb_target_group_arn           = module.archive_ec2.aws_lb_target_group_arn
  aws_ecs_service_lb_task_definition_family     = module.archive_ecs_task_definition.aws_ecs_task_definition_task_family
  aws_ecs_service_lb_task_container_port        = var.aws_ecs_task_container_port
  aws_ecs_service_network_configuration_subnets = ["${module.archive_vpc.aws_default_subnet_a_id}", "${module.archive_vpc.aws_default_subnet_b_id}", "${module.archive_vpc.aws_default_subnet_c_id}", "${module.archive_vpc.aws_default_subnet_d_id}"]
  aws_ecs_sg_name                               = var.archive_ecs_sg_name
  aws_ecs_sg_description                        = var.archive_ecs_sg_description
  aws_ecs_sg_ingress_rules = {
    "rule1" = {
      description     = "Allow All Ingress"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = ["${module.archive_ec2.aws_lb_sg_id}"]
    }
  }
  aws_ecs_sg_egress_rules = {
    "rule1" = {
      description = "Allow All Egress"
      from_port   = 0             # Allowing any incoming port
      to_port     = 0             # Allowing any outgoing port
      protocol    = "-1"          # Allowing any outgoing protocol 
      cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
    }
  }
  depends_on = [module.archive_ecs_task_definition, module.archive_ec2]
}




