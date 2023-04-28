resource "aws_ecr_repository" "assessment_pich_app_ecr" {
  name = "assessment-pich-app-ecr"
  tags = {
    Name = "assessment-pich-app-ecr"
  }
}
