resource "aws_elastic_beanstalk_application" "StoreOne_app" {
  name        = "StoreOne-ebs-wordpress"  # EBS App
  description = "application description"
}

resource "aws_elastic_beanstalk_environment" "StoreOne_app_env" {
  name                = "StoreOne-ebs-wordpress"                                 # EBS ENV
  application         = "${aws_elastic_beanstalk_application.StoreOne_app.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.8.9 running PHP 7.2"
  tier                = "WebServer"

  # VPC -------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.StoreOne-VPC.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.StoreOne-PrivSN1.id}, ${aws_subnet.StoreOne-PrivSN2.id}, ${aws_subnet.StoreOne-PrivSN3.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${aws_subnet.StoreOne-PubSN1.id},${aws_subnet.StoreOne-PubSN2.id},${aws_subnet.StoreOne-PubSN3.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }

  # Load Balancer --------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = "${aws_security_group.StoreOneSG-LB.id}"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = "${aws_security_group.StoreOneSG-LB.id}"
  }

  # AUTOSCALING -------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "myKey"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.StoreOneSG-ec2.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SSHSourceRestriction"
    value     = "tcp, 22, 22, 127.0.0.1/32"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

  # RDS -------------------------------------------------------------------------------------------------------------
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USERNAME"
    value     = "${aws_db_instance.storeone-db.username}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = "${aws_db_instance.storeone-db.password}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_DB_NAME"
    value     = "${aws_db_instance.storeone-db.name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOSTNAME"

    # value     = "${aws_db_instance.storeone-db.endpoint}"                     # this way gets hostname:port = hostname:3306 and does not work. The workaround is below:
    value = "${element(split(":", aws_db_instance.storeone-db.endpoint), 0)}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PORT"
    value     = "3306"
  }
}
