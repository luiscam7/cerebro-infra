// API Gateway

resource "aws_api_gateway_rest_api" "cerebro_api" {
  name        = "CerebroAnalytics"
  description = "API Gateway for Cerebro Platform"
  tags        = local.common_tags
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.cerebro_api.id
  parent_id   = aws_api_gateway_rest_api.cerebro_api.root_resource_id
  path_part   = "eeg"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.cerebro_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = aws_api_gateway_rest_api.cerebro_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.my_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.api_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.cerebro_api.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.cerebro_api.execution_arn}/*/GET/get_raw_eeg_lambda"
}