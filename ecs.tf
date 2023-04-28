resource "aws_ecs_task_definition" "assessment_pich_app_task" {
  family = "assessment-pich-app-ecs-task"

  // Fargate is a type of ECS that requires awsvpc network_mode
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  // Valid sizes are shown here: https://aws.amazon.com/fargate/pricing/
  memory = "512"
  cpu    = "256"

  // Fargate requires task definitions to have an execution role ARN to support ECR images
  execution_role_arn = aws_iam_role.assessment_pich_app_ecs_role.arn

  container_definitions = <<EOT
[
    {
        "name": "assessment-pich-app-ecs-task",
        "image": "984540782578.dkr.ecr.us-east-1.amazonaws.com/assessment-pich-app-ecr:0.0.1",
        "memory": 512,
        "essential": true,
        "portMappings": [
            {
                "containerPort": 3000,
                "hostPort": 3000
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/assessment-pich-app/",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "assessment-pich-app"
          }
        }
    }
]
EOT
}

resource "aws_ecs_cluster" "assessment_pich_app_cluster" {
  name = "assessment-pich-app-ecs"
}

resource "aws_ecs_service" "assessment_pich_app_ecs_service" {
  name = "assessment-pich-app-ecs-service"

  cluster         = aws_ecs_cluster.assessment_pich_app_cluster.id
  task_definition = aws_ecs_task_definition.assessment_pich_app_task.arn

  launch_type   = "FARGATE"
  desired_count = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.assessment_pich_app_task.family
    container_port   = 3000 # Specifying the container port
  }

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.assessment_pich_app_security_group.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "service_security_group" {
  vpc_id = aws_vpc.assessment_pich_app_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}
