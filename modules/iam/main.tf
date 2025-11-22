data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${var.project_name}-lambda-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Permissions for DynamoDB + logs
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [var.dynamodb_table_arn]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${var.aws_region}:${var.account_id}:*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.project_name}-lambda-dynamodb-logs"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Allow Amazon Connect to invoke this Lambda
resource "aws_lambda_permission" "allow_connect_invoke" {
  statement_id = "AllowExecutionFromAmazonConnect"
  action       = "lambda:InvokeFunction"
  # function_name = aws_iam_role.lambda_exec.name # We'll override this in root; see below
  function_name = var.function_name
  principal     = "connect.amazonaws.com"
  source_arn    = "arn:aws:connect:${var.aws_region}:${var.account_id}:instance/*"

  #source_arn    = "arn:aws:connect:us-west-2:${data.aws_caller_identity.current.account_id}:instance/${var.instance_id}"
  depends_on = [var.lambda_depends_on]
}

