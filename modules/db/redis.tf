resource "aws_security_group" "redis-sg" {
  name = var.redis_sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_groups = [var.elb_sg_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name = var.redis_group_name
  subnet_ids = [var.vpc_private_a_id, var.vpc_private_c_id]
}

resource "aws_elasticache_replication_group" "default" {
  replication_group_id = var.redis_group_name
  replication_group_description = "Gitlab Solution"
  node_type = "cache.t3.medium"
  port = 6379
  parameter_group_name          = "default.redis3.2.cluster.on"
  automatic_failover_enabled    = true
  subnet_group_name = aws_elasticache_subnet_group.default.name 

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 2
  }
}

