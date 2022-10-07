# Localstack docs
https://docs.localstack.cloud/get-started/

# using the image
simple `docker-compose up`

# Connecting other images to localstack container
## Using [awslocal](https://github.com/localstack/awscli-local)
Can access localstack from the CLI using awslocal, must set the ENV var `LOCALSTACK_HOST` to point to the localstack container instead of the localhost of the container
## Using SDK (boto3)
Will need valid credentials in one of the expected locations the SDK checks.
The easiest to control is ENV vars.
The boto client endpoints will need to be set to `"http://{LOCALSTACK_ENDPOINT}:4566"` where `LOCALSTACK_ENDPOINT` is the network resolvable hostname of the localstack container (usually same as the container name)