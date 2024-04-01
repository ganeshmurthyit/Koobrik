data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "customerManaged" {
  id = var.vpcId
}

########mws network####
resource "aws_subnet" "public" {
  vpc_id     = data.aws_vpc.customerManaged.id
  cidr_block = cidrsubnet(data.aws_vpc.customerManaged.cidr_block, 3, 0)

  tags = {
    Name = join("", [var.prefix, "-", "publicSubnet", "-", var.suffix])
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.customerManaged.id
  tags = {
    Name = join("", [var.prefix, "-", "igw", "-", var.suffix])
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.customerManaged.id
  route {
    gateway_id = aws_internet_gateway.gw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = join("", [var.prefix, "-", "publicRt", "-", var.suffix])
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_eip" "nat" {
  vpc        = true
  #domain = "vpc"
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = join("", [var.prefix, "-", "eip", "-", var.suffix])
  }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = join("", [var.prefix, "-", "nat", "-", var.suffix])
  }
}

resource "aws_subnet" "private" {
  vpc_id     = data.aws_vpc.customerManaged.id
  cidr_block = cidrsubnet(data.aws_vpc.customerManaged.cidr_block, 3, 1)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = join("", [var.prefix, "-", "privateSubnet", "-", var.suffix])
  }
}

resource "aws_subnet" "privateSecondary" {
  vpc_id     = data.aws_vpc.customerManaged.id
  cidr_block = cidrsubnet(data.aws_vpc.customerManaged.cidr_block, 3, 2)
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = join("", [var.prefix, "-", "privateSubnetSecondary", "-", var.suffix])
  }
}

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.customerManaged.id
  route {
    nat_gateway_id = aws_nat_gateway.gw.id
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = join("", [var.prefix, "-", "privateRt", "-", var.suffix])
  }
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_route_table_association" "privateSecondary" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.privateSecondary.id
}

resource "aws_security_group" "this" {
  name        = join("", [var.prefix, "-", "sg", "-", var.suffix])
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.customerManaged.id

  ingress {
    description = "All Internal TCP"
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    self        = true
  }

  ingress {
    description = "All Internal UDP"
    protocol    = "udp"
    from_port   = 0
    to_port     = 65535
    self        = true
  }

  ingress {
    //cidr_blocks = local.allows[var.region]
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    //cidr_blocks = local.allows[var.region]
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  ingress {
    //cidr_blocks = local.allows[var.region]
    description = "proxy"
    from_port   = 5557
    to_port     = 5557
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.2.0"

  vpc_id             = data.aws_vpc.customerManaged.id
  security_group_ids = [aws_security_group.this.id]

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
      route_table_ids = flatten([
        aws_route_table.public.id,
      aws_route_table.private.id])
    }
  }
  tags = {
    Name = join("", [var.prefix, "-", "vpcEndpoint", "-", var.suffix])
  }
}


resource "databricks_mws_networks" "thisNet" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = join("", [var.prefix, "-", "network", "-", var.suffix])
  subnet_ids         = [aws_subnet.private.id, aws_subnet.privateSecondary.id]
  vpc_id             = data.aws_vpc.customerManaged.id
  security_group_ids = [aws_security_group.this.id]
}
