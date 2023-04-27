resource "aws_iam_role" "assessment_pich_app_ecs_role" {
  name               = "assessment-pich-app-ecs-role"
  assume_role_policy = data.aws_iam_policy_document.assessment_pich_app_ecs_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "assessment_pich_app_ecs_policy_attachment" {
  role = aws_iam_role.assessment_pich_app_ecs_role.name
  // This policy adds logging + ecr permissions
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
