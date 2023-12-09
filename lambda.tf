// Lambda functions

resource "aws_lambda_function" "get_raw_eeg_lambda" {
  function_name = "CerebroPlatform_Get_Raw_EEG_Data"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_execution_role.arn
  tags          = local.common_tags

  s3_bucket = aws_s3_bucket.my_bucket.bucket
  s3_key    = "path/to/your/lambda.zip"
}