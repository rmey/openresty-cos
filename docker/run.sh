#!/bin/sh
# check for value of COS HTTPS URL like this https://s3.eu-de.objectstorage.softlayer.net/YOURBUCKET
# without trailing slash
echo "COS endpoint to static webfiles": $COS_ENDPOINT
# COS access key
echo "COS S3 Access KEY": $S3_ACCESS_KEY
# COS access key
echo "COS S3 Secret KEY": $S3_SECRET_KEY
# S3 Bucket name
echo "Bucket": $S3_BUCKET
# S3 COS uri
echo "COS_URI": $COS_URI

if [ -z "$COS_ENDPOINT" ] || [ -z "$COS_URI" ] || [ -z "$S3_ACCESS_KEY" ] || [ -z "$S3_SECRET_KEY" ] || [ -z "$S3_BUCKET" ]; then
    echo "Variables not set exiting"
    exit;
fi

# this is the only variable I need to replace with sed for proxy_pass
# otherwise I would need to set a resolver
# see https://stackoverflow.com/questions/17685674/nginx-proxy-pass-with-remote-addr
sed -i "s,COS_URI,${COS_URI},g" /usr/local/openresty/nginx/conf/nginx.conf
cat /usr/local/openresty/nginx/conf/nginx.conf

nginx -g 'daemon off; error_log /dev/stderr debug;'
