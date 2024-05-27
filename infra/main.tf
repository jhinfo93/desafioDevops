resource "aws_amplify_app" "example" {
  name       = "${var.name}-${terraform.workspace}"
  repository = var.repository
  access_token = var.access_token

  build_spec = templatefile("${path.module}/amplify.yml.tpl",
    {
      testeEnv = "${terraform.workspace}-${var.name}"
    }
  )
}

resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.example.id
  branch_name = var.branch_name

  framework = "React"
  stage     = "PRODUCTION"
}

resource "aws_amplify_webhook" "master" {
  app_id      = aws_amplify_app.example.id
  branch_name = aws_amplify_branch.master.branch_name
  description = "triggermaster"
}