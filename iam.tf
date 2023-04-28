resource "aws_iam_role" "assessment_pich_app_ecs_role" {
  name               = "assessment-pich-app-ecs-role"
  assume_role_policy = data.aws_iam_policy_document.assessment_pich_app_ecs_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "assessment_pich_app_ecs_policy_attachment" {
  role = aws_iam_role.assessment_pich_app_ecs_role.name
  // This policy adds logging + ecr permissions
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "assessment_pich_app_codepipeline_role" {
  name               = "assessment-pich-app-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assessment_pich_app_codepipeline_assume_role_policy.json
}

resource "aws_iam_role_policy" "assessment_pich_app_codepipeline_policy" {
  name   = "assessment-pich-app-codepipeline-policy"
  role   = aws_iam_role.assessment_pich_app_codepipeline_role.id
  policy = data.aws_iam_policy_document.assessment_pich_app_codepipeline_policy.json
}

resource "aws_iam_role" "assessment_pich_app_codebuild_role" {
  name               = "assessment-pich-app-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.assessment_pich_app_codebuild_assume_role_policy.json
}

resource "aws_iam_role_policy" "assessment_pich_app_codebuild_policy" {
  name   = "assessment-pich-app-codebuild-policy"
  role   = aws_iam_role.assessment_pich_app_codebuild_role.name
  policy = data.aws_iam_policy_document.assessment_pich_app_codebuild_policy.json
}
