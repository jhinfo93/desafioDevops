resource "aws_amplify_app" "example" {
  name       = "${var.name}-${terraform.workspace}"
  repository = var.repository
  access_token = var.access_token
  
  enable_branch_auto_build = true
  
  environment_variables = {
    ENV = "test"
  }
  
  platform                 = "WEB_COMPUTE"

  build_spec = templatefile("${path.module}/amplify.yml.tpl",
    {
      testeEnv1 = "${terraform.workspace}-${var.name}-1",
      testeEnv2 = "${terraform.workspace}-${var.name}-2",
      
    }
  )

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }
}

resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.example.id
  branch_name = var.branch_name

  framework = "Next.js - SSR"
  stage     = "PRODUCTION"
}

resource "aws_amplify_webhook" "master" {
  app_id      = aws_amplify_app.example.id
  branch_name = aws_amplify_branch.master.branch_name
  description = "triggermaster"
}