terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }



  
  backend "s3" {
    bucket         = "state-dani357"  
    key            = "web-simple/terraform.tfstate"    
    region         = "us-east-1"                     
    dynamodb_table = "almacen_estado"  
    encrypt        = true                              
  }
}

provider "aws" {
  shared_config_files      = ["/Users/Usuario/.aws/config"]
  shared_credentials_files = ["/Users/Usuario/.aws/credentials"]
}

resource "aws_instance" "instancia" {
  ami                         = var.ami
  instance_type               = var.instancia
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.grupo_seguridad.id]
  key_name                    = var.key_name
  
  user_data = file("${path.module}/configuracion.sh")

}

output "public_ip" {
  value = aws_instance.instancia.public_ip
}

resource "aws_security_group" "grupo_seguridad" {
  name        = "grupo_seguridad"
  description = "grupo_seguridad"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grupo_seguridad"
  }
}


