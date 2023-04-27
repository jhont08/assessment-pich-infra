config {
  module = true
}

plugin "aws" {
  enabled = true
  version = "0.13.2"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Specific Rules https://github.com/terraform-linters/tflint-ruleset-aws/blob/master/docs/rules/README.md

rule "aws_resource_missing_tags" {
  enabled = true
  tags=["Name"]
}

# General Rules on Terraform

rule "terraform_deprecated_interpolation" {
  enabled = true
}
rule "terraform_unused_declarations" {
  enabled = true
}
rule "terraform_comment_syntax" {
  enabled = true
}
rule "terraform_documented_outputs" {
  enabled = true
}
rule "terraform_documented_variables" {
  enabled = true
}
rule "terraform_typed_variables" {
  enabled = true
}
rule "terraform_module_pinned_source" {
  enabled = true
}
rule "terraform_required_version" {
  enabled = true
}
rule "terraform_deprecated_index" {
  enabled = true
}
rule "terraform_naming_convention" {
  enabled = true
}
rule "terraform_standard_module_structure" {
  enabled = true
}
