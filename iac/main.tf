module "vpc" {
  source                            = "./vpc"
  tags                              = local.tags
  meta                              = local.meta
}

module "sg" {
  source                            = "./sg"
  tags                              = local.tags
  meta                              = local.meta
  vpc_id                            = module.vpc.vpc_id
  vpc_cidr                          = module.vpc.vpc_cidr
}

module "alb" {
  source                            = "./alb"
  tags                              = local.tags
  meta                              = local.meta
  vpc_id                            = module.vpc.vpc_id
  public_subnet_ids                 = module.vpc.public_subnet_ids
  security_groups                   = [module.sg.sg_alb_id]
  alb_certificate_arn               = "xyz"
}

module "iam" {
  source                            = "./iam"
  tags                              = local.tags
  meta                              = local.meta
}

module "ecs" {
  source                            = "./ecs"
  tags                              = local.tags
  meta                              = local.meta
  ecs_task_role_arn                 = module.iam.iam_role_arn
  ecs_execution_role_arn            = module.iam.iam_role_arn
  ecs_service_role                  = module.iam.iam_role_arn
  alb_tg_arn                        = module.alb.alb_tg_arn
  cpu                               = 2048
  memory                            = 4096
  dcc                               = 1
  min_cc                            = 1
  max_cc                            = 2
  resource_label                    = "${module.alb.alb_arn_suffix}/${module.alb.alb_tg_arn_suffix}"
  private_subnet_ids                = module.vpc.private_subnet_ids
  ecr_repo_url                      = module.ecr.ecr_repo_url
  cloudwatch_log_group_arn          = module.cloudwatch.cloudwatch_log_group_arn
  security_groups                   = [module.sg.sg_ecs_id]
}

module "cloudwatch" {
  source                            = "./cloudwatch"
  tags                              = local.tags
  meta                              = local.meta
}