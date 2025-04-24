variable "lb_name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "internal" {
  description = "Whether the LB is internal or internet-facing"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "List of security group IDs for the LB"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets for the LB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID for Target Group"
  type        = string
}

variable "target_group_name" {
  description = "Target Group Name"
  type        = string
}

variable "target_port" {
  description = "Port for Target Group"
  type        = number
}

variable "target_protocol" {
  description = "Protocol for Target Group"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Target Type (instance, ip, lambda)"
  type        = string
  default     = "ip"
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "listener_port" {
  description = "Listener Port"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Listener Protocol"
  type        = string
  default     = "HTTP"
}
