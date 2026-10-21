# INTENTIONALLY INSECURE TEST FIXTURE.
# Never deploy this configuration.

resource "aws_s3_bucket" "test_bucket" {
  bucket = "portfolio-insecure-test-bucket"
}