### lambda.tf

# lambda.tf
# Add Lambda functions for creating automated backups and EventBridge rules for scheduling.
resource "aws_lambda_function" "rds_snapshot" {
  function_name = var.lambda_function_name
  role          = var.lambda_execution_role_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  s3_bucket     = var.lambda_code_bucket
  s3_key        = var.lambda_code_key

  # If you need to pass environment variables to Lambda
  environment {
    variables = {
      DB_INSTANCE_IDENTIFIER = aws_db_instance.postgresql.id
    }
  }
}

# Create a CloudWatch Event Rule to trigger Lambda at midnight
resource "aws_cloudwatch_event_rule" "midnight_event" {
  name                = "MidnightSnapshotRule"
  schedule_expression = "cron(0 0 * * ? *)"  # Trigger Lambda every day at midnight UTC
}

# Set up CloudWatch Event Target to trigger the Lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.midnight_event.name
  target_id = "RdsSnapshotLambda"
  arn       = aws_lambda_function.rds_snapshot.arn
}

# Allow CloudWatch Events to invoke the Lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_snapshot.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.midnight_event.arn
}

