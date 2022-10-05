
resource "aws_opensearch_domain_policy" "main" {
  domain_name = aws_opensearch_domain.example.domain_name

  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Condition": {
                "IpAddress": {"aws:SourceIp": "127.0.0.1/32"}
            },
            "Resource": "${aws_opensearch_domain.example.arn}/*"
        }
    ]
}
POLICIES
}