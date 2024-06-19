output "domain_name" {
    value = "https://${var.branch_name}.${module.amplify.amplify.default_domain}"
}

output "id" {
    value = module.amplify.amplify.id
}
