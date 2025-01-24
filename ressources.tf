# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


# Création du VPC

resource "aws_vpc" "VPC-cluster" {
  cidr_block = "10.8.0.0/16"
  tags = {
    Name = "cluster-VPC"
  }
}

# Création des sous-réseaux publics
resource "aws_subnet" "SUB-1" {
  vpc_id     = aws_vpc.VPC-cluster.id
  cidr_block = "10.8.1.0/24"
  availability_zone = "us-east-1a"

}

resource "aws_subnet" "SUB-2" {
  vpc_id     = aws_vpc.VPC-cluster.id
  cidr_block = "10.8.2.0/24"
  availability_zone = "us-east-1b"

}
# Création de la table de routage
resource "aws_route_table" "cluster-Table" {
  vpc_id = aws_vpc.VPC-cluster.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW-cluster.id
  }

  tags = {
    Name = "Table_cluster"
  }
}
    
# Association des sous-réseaux à la table de routage
resource "aws_route_table_association" "Ass1" {
  subnet_id      = aws_subnet.Sub-1.id
  route_table_id = aws_route_table.cluster-Table.id
}

resource "aws_route_table_association" "Ass2" {
  subnet_id      = aws_subnet.Sub-2.id
  route_table_id = aws_route_table.cluster-Table.id
}

# Création de l'Internet Gateway
resource "aws_internet_gateway" "IGW-cluster" {
  vpc_id = aws_vpc.VPC-cluster.id

  tags = {
    Name = "IGW-cluster"
  }
}
# Création du Security Group

resource "aws_security_group" "Aut_http" {
  name        = "Aut_http"
  description = "AUT HTTP traffic"
  vpc_id      = aws_vpc.VPC-cluster.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "AUTH_http"
  }
}
