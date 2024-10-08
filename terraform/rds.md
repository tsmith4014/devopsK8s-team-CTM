### rds.tf
# rds.tf

locals {
  sanitized_timestamp = replace(replace(replace(replace(timestamp(), ":", ""), "-", ""), "T", ""), "Z", "")
}

resource "aws_db_instance" "postgresql" {
  identifier         = var.rds_instance_name
  engine             = var.rds_engine
  engine_version     = var.rds_engine_version
  instance_class     = var.rds_instance_class
  allocated_storage  = var.rds_allocated_storage
  username           = var.db_username
  password           = var.db_password
  db_name            = var.db_name
  skip_final_snapshot = false

  final_snapshot_identifier = "${var.final_snapshot_identifier}-${local.sanitized_timestamp}"

  vpc_security_group_ids = [aws_security_group.shredder_node_sg1.id]

}

#   final_snapshot_identifier = var.final_snapshot_identifier

#   vpc_security_group_ids = [aws_security_group.shredder_node_sg1.id]
# }

# Explanation:
# timestamp(): Returns a string with characters that are not allowed.
# replace(): Used to remove disallowed characters.
# The local block defines a local value sanitized_timestamp with all disallowed characters removed.

