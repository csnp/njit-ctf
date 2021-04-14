module "redis" {
    source = "cloudposse/elasticache-redis/aws"
    version = "0.32.1"

    availability_zones         = var.azs
    namespace                  = "${var.environment}-${var.name}"
    stage                      = var.environment
    name                       = "${var.environment}-${var.name}"
    zone_id                    = ""
    vpc_id                     = data.aws_vpc.current.id
    allowed_cidr_blocks        = [data.aws_vpc.current.cidr_block]
    subnets                    = data.aws_subnet_ids.private_subnets.ids
    cluster_size               = var.cluster_size
    instance_type              = var.instance_type
    apply_immediately          = true
    automatic_failover_enabled = false
    engine_version             = "5.0.6"
    family                     = var.family
    at_rest_encryption_enabled = true
    transit_encryption_enabled = false
    multi_az_enabled = false
}