import os
import json
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def lambda_handler(event, context):
    # event structure from Amazon Connect Lambda invocation
    # event["Details"]["Parameters"] can contain things you pass from the flow
    # event["Details"]["ContactData"]["Attributes"] contains existing attributes

    locale = "en"
    try:
        locale = event["Details"]["ContactData"]["CustomerEndpoint"]["CountryCode"].lower()
    except Exception:
        pass

    # For now, just en/es toggle
    if locale not in ("en", "es"):
        locale = "en"

    # Fetch main menu prompt from DynamoDB
    main_menu_key = f"prompt:main_menu:{locale}"

    resp = table.get_item(Key={"config_key": main_menu_key})
    main_menu_text = resp.get("Item", {}).get("text", "Welcome to Ambazonia DMV.")

    # Return keys that show up as Contact Attributes in Connect
    return {
        "main_menu_prompt": main_menu_text,
        "language": locale
    }
