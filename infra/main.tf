module "amplify" {
  source = "./module/aws_amplify"
  name = var.name
  repository = var.repository
  access_token = var.access_token
  branch_name = var.branch_name
}