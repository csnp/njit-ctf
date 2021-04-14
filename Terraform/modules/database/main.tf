module "rds" {
  source  = "./db_module"

  # insert the 14 required variables here
  identifier = var.db_identifier
  

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = var.instance_size
  allocated_storage = var.storage_gb
  storage_encrypted = var.encrypted_storage

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name     = var.db_identifier
  username = "user"

  # change the password after creation
  # The password can include any printable ASCII character except "/", """, or "@".
  # 8 char min

  password = "sijmsoifjoqnj2nwnjkJ"
  port     = "3306"


  vpc_security_group_ids = [aws_security_group.db.id]

  maintenance_window = "Mon:04:00-Mon:09:00"
  backup_window      = "01:00-03:50"

  multi_az = false

  # disable backups to create DB faster
  backup_retention_period = 7

  tags = var.tags

  #enabled_cloudwatch_logs_exports = ["audit", "general"]

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.private_subnets.ids

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"
  apply_immediately = true

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.db_identifier

  # Database Deletion Protection
  deletion_protection = var.deletion_protection

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  # options = [
  #   {
  #     option_name = "MARIADB_AUDIT_PLUGIN"

  #     option_settings = [
  #       {
  #         name  = "SERVER_AUDIT_EVENTS"
  #         value = "CONNECT"
  #       },
  #       {
  #         name  = "SERVER_AUDIT_FILE_ROTATIONS"
  #         value = "37"
  #       },
  #     ]
  #   },
  # ]
}