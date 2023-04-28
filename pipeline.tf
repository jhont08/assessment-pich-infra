resource "aws_codestarconnections_connection" "github" {
  name          = "github-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "assessment-pich-app-pipeline"
  role_arn = aws_iam_role.assessment_pich_app_codepipeline_role.arn

  artifact_store {
    location = "jftriana-artifacts"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "jhont08/assessment-pich-app"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.assessment_pich_app_project.name
      }
    }
  }
}

resource "aws_codebuild_project" "assessment_pich_app_project" {
  name          = "assessment-pich-app-project"
  description   = "Build and Deploy Assessment App"
  service_role  = aws_iam_role.assessment_pich_app_codebuild_role.arn
  build_timeout = "5"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "assessment-pich-app-ecr"
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "0.0.1"
    }
    environment_variable {
      name  = "ECS_CLUSTER_NAME"
      value = aws_ecs_cluster.assessment_pich_app_cluster.name
    }
    environment_variable {
      name  = "ECS_SERVICE_NAME"
      value = aws_ecs_service.assessment_pich_app_ecs_service.name
    }
    environment_variable {
      name  = "ECS_TASK_DEFINITION"
      value = aws_ecs_task_definition.assessment_pich_app_task.family
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "arn:aws:s3:::jftriana-artifacts/assessment-pich-app-buildspecs/buildspec.yml"
  }
}
