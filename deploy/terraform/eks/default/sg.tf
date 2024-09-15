resource "aws_security_group" "nestjs_backend" {
  name        = "${var.environment_name}-nestjs_backend"
  description = "Security group for nestjs_backend component"
  vpc_id      = module.vpc.inner.vpc_id

  ingress {
    description = "Allow inbound HTTP API traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  ingress {
    description = "Allow inbound Istio healthchecks"
    from_port   = 15020
    to_port     = 15021
    protocol    = "tcp"
    cidr_blocks = [module.vpc.inner.vpc_cidr_block]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.tags.result
}
