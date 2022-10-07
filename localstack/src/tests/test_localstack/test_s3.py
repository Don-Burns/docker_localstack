import os
import boto3
from mypy_boto3_s3 import S3Client


def create_bucket(client, bucket_name: str, region: str):
    client.create_bucket(
        Bucket=bucket_name,
        CreateBucketConfiguration={"LocationConstraint": region},
    )


def test_creating_a_bucket(s3_client: S3Client):
    bucket_name = "pytest"
    region = "us-east-1"
    create_bucket(client=s3_client, bucket_name=bucket_name, region=region)

    bucket = s3_client.get_bucket_location(Bucket=bucket_name)

    assert bucket.get("ResponseMetadata").get("HTTPStatusCode") == 200
