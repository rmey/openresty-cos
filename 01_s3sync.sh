#!/bin/sh
source ./env.local
echo sync static webfiles to IBM Cloud Object Storage
s3cmd sync -v --host-bucket=$COS_HOST_BUCKET --host=$COS_ENDPOINT --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET_KEY -v --acl-private -r ./wwwroot/ s3://$S3_BUCKET
