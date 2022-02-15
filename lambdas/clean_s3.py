# Cleans s3 buckets of all files older than a certain date


# Imports
import boto3
import datetime


# Constants
DAYS_RETAINED = 1
WHITELISTED_KEYS = ["test-folder-1/junk-in-folder-2.txt", "JUNK OUT FOLDER 1.txt"]
S3_BUCKET_NAMES = ["kage-kowalski-bucket"]


# Cleans s3 buckets
def clean_s3():
    # Setup session and client
    session = boto3.Session()
    client = session.client('s3', 'us-west-2')

    # Loop through buckets
    for s3_bucket_name in S3_BUCKET_NAMES:
        print("\nOpening bucket: " + s3_bucket_name)
        response = client.list_objects_v2(Bucket=s3_bucket_name)

        # Loop through items in current bucket
        for item in response['Contents']:
            print("Examining object: " + item['Key'])

            # Skip directories, whitelisted files, and new files; delete everything else
            if item['Key'].endswith('/') or (item['Key'] in WHITELISTED_KEYS) or is_new(item['LastModified']):
                print("Skipping object: " + item['Key'])
            else:
                print('Deleting object: ', item['Key'])
                client.delete_object(Bucket=s3_bucket_name, Key=item['Key'])


# Supporting function that returns True if passed datetime is DAYS_RETAINED days old or newer
def is_new(item_date):
    cur_date = datetime.datetime.now()
    time_delta = datetime.timedelta(days=DAYS_RETAINED)
    threshold_date = cur_date - time_delta
    return item_date > threshold_date


# Lambda handler
def lambda_handler(event, context):
    clean_s3()

