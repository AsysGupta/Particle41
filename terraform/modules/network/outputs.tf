output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "The IDs of the created public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the created private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "nat_gateway_ids" {
  description = "The IDs of the created NAT gateways"
  value       = aws_nat_gateway.arc_nat_gateway[*].id
}

output "eip_ids" {
  description = "The IDs of the created Elastic IPs for NAT gateways"
  value       = aws_eip.arc_eip[*].id
}
