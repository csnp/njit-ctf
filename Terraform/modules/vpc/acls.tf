locals {
  network_acls = {
    public_inbound = [
      {
        rule_number = 91
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
      },
      #todo: restrict these later
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = var.cidr_block
      },
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ]
    public_outbound = [
      {
        rule_number = 91
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = var.cidr_block
      },      
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ],
    private_inbound = [
      # allow all internal traffic
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "-1"
        cidr_block  = var.cidr_block
      },
      # allow ephemeral ports
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
      }
    ],
    private_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "-1"
        cidr_block  = var.cidr_block
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = "-1"
        cidr_block  = "0.0.0.0/0"
      }
    ]
  }
}
