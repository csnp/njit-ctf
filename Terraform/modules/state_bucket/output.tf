output "state_bucket" {
  description = "ID of the state bucket"
  value       = aws_s3_bucket.state.id
}