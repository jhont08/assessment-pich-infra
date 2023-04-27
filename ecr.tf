resource "aws_ecr_repository" "ecr_repo" {
  name = "ecr-app-repo"
  tags = {
    Name = "ecr-app-repo"
  }
}
