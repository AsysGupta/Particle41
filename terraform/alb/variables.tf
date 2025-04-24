variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_port" {
  description = "Target port for the target group"
  type        = number
}

variable "target_protocol" {
  description = "Protocol for the target group"
  type        = string
}

variable "target_type" {
  description = "Target type for the target group (instance or ip)"
  type        = string
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
}

variable "listener_port" {
  description = "Port for the listener"
  type        = number
}

variable "listener_protocol" {
  description = "Protocol for the listener"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}