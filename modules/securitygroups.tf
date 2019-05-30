resource "aws_security_group" "StoreOneSG-DB" {
  # SG - DB  -------------------------------------------------------- DB Tier Security Group
  name = "StoreOneSG-DB" # SG 3306 

  vpc_id = "${aws_vpc.StoreOne-VPC.id}"

  tags = {
    Name = "StoreOneSG-DB-EBS"
  }

  ingress {
    from_port   = 3306          # MariaDB port
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow-maria-db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.StoreOneSG-DB.id}"
  source_security_group_id = "${aws_security_group.StoreOneSG-ec2.id}"
}

resource "aws_security_group" "StoreOneSG-ec2" {
  # SG - ec2  -------------------------------------------------------- Web/App Tier Security Group
  name = "StoreOneSG-ec2-EBS" # SG 22

  vpc_id = "${aws_vpc.StoreOne-VPC.id}"

  tags = {
    Name = "StoreOneSG-ec2"
  }

  ingress {
    from_port   = 22            # SSH Port
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow-http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.StoreOneSG-ec2.id}"
  source_security_group_id = "${aws_security_group.StoreOneSG-LB.id}"
}

resource "aws_security_group" "StoreOneSG-LB" {
  # SG - LB  -------------------------------------------------------- ELB Security Group
  name = "StoreOneSG-LB-EBS" # SG 80

  vpc_id = "${aws_vpc.StoreOne-VPC.id}"

  tags = {
    Name = "StoreOneSG-LB"
  }

  ingress {
    from_port   = 80            # HTTP Port
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
