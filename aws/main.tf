locals {
  effective_vpc_mode    = try(trimspace(var.vpc_selection), "") != "" ? try(trimspace(var.vpc_selection), "") : var.vpc_mode
  effective_subnet_mode = try(trimspace(var.subnet_selection), "") != "" ? try(trimspace(var.subnet_selection), "") : var.subnet_mode
}

data "aws_vpc" "existing" {
  count = local.effective_vpc_mode == "existing" ? 1 : 0

  id = var.vpc_id
}

resource "aws_vpc" "new" {
  count = local.effective_vpc_mode == "create_new" ? 1 : 0

  cidr_block           = var.new_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.instance_name}-vpc"
  }
}

locals {
  vpc_id = local.effective_vpc_mode == "create_new" ? aws_vpc.new[0].id : data.aws_vpc.existing[0].id
}

data "aws_subnet" "existing" {
  count = local.effective_subnet_mode == "existing" ? 1 : 0

  id = var.subnet_id
}

resource "aws_subnet" "new" {
  count = local.effective_subnet_mode == "create_new" ? 1 : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.new_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.instance_name}-subnet"
    Type = var.subnet_type
  }
}

locals {
  subnet_id = local.effective_subnet_mode == "create_new" ? aws_subnet.new[0].id : data.aws_subnet.existing[0].id
}

resource "aws_internet_gateway" "new" {
  count = local.effective_vpc_mode == "create_new" ? 1 : 0

  vpc_id = local.vpc_id

  tags = {
    Name = "${var.instance_name}-igw"
  }
}

resource "aws_route_table" "public" {
  count = local.effective_vpc_mode == "create_new" ? 1 : 0

  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.new[0].id
  }

  tags = {
    Name = "${var.instance_name}-public-routes"
  }
}

resource "aws_route_table_association" "public" {
  count = local.effective_vpc_mode == "create_new" && local.effective_subnet_mode == "create_new" ? 1 : 0

  route_table_id = aws_route_table.public[0].id
  subnet_id     = local.subnet_id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  associate_public_ip_address = var.associate_public_ip

  tags = {
    Name = var.instance_name
  }
}