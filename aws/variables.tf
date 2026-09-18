variable "instance_name" {
  description = "Name assigned to the EC2 instance."
  type        = string
  default     = "demo-instance"

  validation {
    condition     = length(trimspace(var.instance_name)) > 0
    error_message = "instance_name must not be empty."
  }
}

variable "instance_type" {
  description = "EC2 instance type, mapped from the Nudgebee INSTANCE_SKU value."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]+\\.[a-z0-9]+$", var.instance_type))
    error_message = "instance_type must be a valid EC2 instance type such as t3.micro."
  }
}

variable "aws_region" {
  description = "AWS region in which to provision the instance."
  type        = string
  default     = "us-west-2"

  validation {
    condition     = can(regex("^[a-z]{2}(-gov|-iso|-isob)?-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "aws_region must be a valid AWS region such as us-east-1."
  }
}

variable "availability_zone" {
  description = "Availability zone for a newly created subnet."
  type        = string
  default     = "us-west-2a"

  validation {
    condition     = can(regex("^[a-z]{2}(-gov|-iso|-isob)?-[a-z]+-[0-9]+[a-z]$", var.availability_zone))
    error_message = "availability_zone must be a valid availability zone such as us-west-2a. Depending on the VPC region"
  }
}

variable "vpc_mode" {
  description = "Whether to create a VPC or use an existing VPC."
  type        = string
  default     = "create_new"

  validation {
    condition     = contains(["create_new", "existing"], var.vpc_mode)
    error_message = "vpc_mode must be either create_new or existing."
  }
}

variable "vpc_selection" {
  description = "Backward-compatible alias for the VPC selection provided by the runner."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_selection == null ? true : contains(["create_new", "existing"], var.vpc_selection)
    error_message = "vpc_selection must be either create_new or existing."
  }
}

variable "new_vpc_cidr" {
  description = "CIDR block for a newly created VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.new_vpc_cidr, 0))
    error_message = "new_vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "vpc_id" {
  description = "ID of an existing VPC when vpc_mode is existing."
  type        = string
  default     = ""

  validation {
    condition     = var.vpc_id == "" || can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id must be empty or a valid AWS VPC ID."
  }
}

variable "subnet_mode" {
  description = "Whether to create a subnet or use an existing subnet."
  type        = string
  default     = "create_new"

  validation {
    condition     = contains(["create_new", "existing"], var.subnet_mode)
    error_message = "subnet_mode must be either create_new or existing."
  }
}

variable "subnet_selection" {
  description = "Backward-compatible alias for the subnet selection provided by the runner."
  type        = string
  default     = ""

  validation {
    condition     = var.subnet_selection == null ? true : contains(["create_new", "existing"], var.subnet_selection)
    error_message = "subnet_selection must be either create_new or existing."
  }
}

variable "new_subnet_cidr" {
  description = "CIDR block for a newly created subnet."
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.new_subnet_cidr, 0))
    error_message = "new_subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "subnet_type" {
  description = "Subnet classification supplied by the runner."
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.subnet_type)
    error_message = "subnet_type must be either public or private."
  }
}

variable "subnet_id" {
  description = "ID of an existing subnet when subnet_mode is existing."
  type        = string
  default     = ""

  validation {
    condition     = var.subnet_id == "" || can(regex("^subnet-[0-9a-f]+$", var.subnet_id))
    error_message = "subnet_id must be empty or a valid AWS subnet ID."
  }
}

variable "associate_public_ip" {
  description = "Whether to associate a public IPv4 address with the instance."
  type        = bool
  default     = true
}
