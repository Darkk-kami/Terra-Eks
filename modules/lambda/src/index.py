import json
import boto3
import os

# Initialize SES client
ses_client = boto3.client('ses')

def handler(event, context):
    """
    AWS Lambda function to process S3 events and send email notifications using SES.
    """
    # Extract S3 event details
    try:
        records = event.get('Records', [])
        if not records:
            print("No records found in the event.")
            return

        for record in records:
            s3_info = record['s3']
            bucket_name = s3_info['bucket']['name']
            object_key = s3_info['object']['key']

            # Format email content
            email_subject = f"New Object Uploaded to S3 Bucket: {bucket_name}"
            email_body = (
                f"A new object has been uploaded to the S3 bucket '{bucket_name}'.\n\n"
                f"Object Key: {object_key}\n\n"
                "You can log in to your AWS account for more details."
            )

            # Send email via SES
            response = ses_client.send_email(
                Source=os.environ['SES_SOURCE_EMAIL'],
                Destination={
                    'ToAddresses': [
                        os.environ['SES_DESTINATION_EMAIL']  
                    ]
                },
                Message={
                    'Subject': {'Data': email_subject},
                    'Body': {'Text': {'Data': email_body}}
                }
            )

            print(f"Email sent successfully. Response: {response}")
    except Exception as e:
        print(f"Error processing event: {e}")
        raise e