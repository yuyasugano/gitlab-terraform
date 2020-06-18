output "gitlab_vpc_id" {
  value = aws_vpc.gitlab.id
}

output "vpc_public_a_id" {
  value = aws_subnet.gitlab-public-a.id
}

output "vpc_public_c_id" {
  value = aws_subnet.gitlab-public-c.id
}

output "vpc_private_a_id" {
  value = aws_subnet.gitlab-private-a.id
}

output "vpc_private_c_id" {
  value = aws_subnet.gitlab-private-c.id
}
