# pylint: disable=redefined-outer-name
# pylint: disable=missing-module-docstring
import os
import pytest
import boto3
from mypy_boto3_s3 import S3Client


@pytest.fixture(scope="session")
def LOCALSTACK_ENDPOINT() -> str:
    return f"""http://{os.environ.get("LOCALSTACK_HOST")}:4566"""


@pytest.fixture(scope="module")
def s3_client(LOCALSTACK_ENDPOINT: str) -> S3Client:
    return boto3.client("s3", endpoint_url=LOCALSTACK_ENDPOINT)  # type: ignore
