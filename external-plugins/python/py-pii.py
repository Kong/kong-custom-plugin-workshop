#!/usr/bin/env python3
import os
import kong_pdk.pdk.kong as kong
from azure.ai.textanalytics import TextAnalyticsClient
from azure.core.credentials import AzureKeyCredential

Schema = (
    {
        "auth_endpoint": {
            "type": "string",
            "required": True,
            "default": "https://kongwarrencs.cognitiveservices.azure.com"
        }
    },
    {
        "subscription_key": {
            "type": "string",
            "required": True,
            "default": "<Azure Cognitive Service Subscription Key>"
        }
    }
)

version = '0.1.0'
priority = 0

# This is an example plugin that add a header to the response

class Plugin(object):
    def __init__(self, config):
        self.config = config

    def response(self, kong: kong.kong):

        pii_entities = []

        client = TextAnalyticsClient(
                endpoint=self.config['auth_endpoint'], 
                credential=AzureKeyCredential(self.config['subscription_key']))

        raw_body = str(kong.service.response.get_raw_body())
        kong.log.info(self.config['auth_endpoint'])
        kong.log.info(self.config['subscription_key'])
        kong.log.info(raw_body)
        response = client.recognize_pii_entities([raw_body], language="en")
        result = [doc for doc in response if not doc.is_error]
        for doc in result:
            for entity in doc.entities:
                pii_entities.append(entity.category)

        if pii_entities:
            kong_response_body = 'Not available as the response have PII entity: ' + ', '.join(pii_entities)
        else:
            kong_response_body = raw_body
            # kong_response_body = 'No PII'

        kong.response.exit(kong.response.get_status(), kong_response_body)


# add below section to allow this plugin optionally be running in a dedicated process
if __name__ == "__main__":
    from kong_pdk.cli import start_dedicated_server
    start_dedicated_server("py-hello", Plugin, version, priority, Schema)
