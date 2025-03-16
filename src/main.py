import logging

import requests


def get_labmda_ip() -> str:
    """
    Get the IP address of the Lambda function

    Returns:
        str: The IP address of the Lambda function
    """
    res = requests.get("https://ident.me")

    return res.text


def lambda_handler(event: dict, context: object) -> dict:
    l = logging.getLogger(__name__)
    l.info("Received event: %s", event)

    return {"statusCode": 200, "body": "Hello from uv-sam-trivy-template!"}
