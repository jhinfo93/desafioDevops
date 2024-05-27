resource "aws_amplify_app" "example" {
  name       = "example"
  repository = "https://github.com/jhinfo93/desafioDevops"

  # GitHub personal access token
  access_token = var.access_token
}