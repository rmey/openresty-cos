#!/bin/sh
# without trailing slash
echo "COS endpoint to static webfiles": $COS_ENDPOINT
# COS access key
tmp=$S3_ACCESS_KEY
echo "COS S3 Access KEY:" "${tmp//?/*}"
# COS access key
tmp=$S3_SECRET_KEY
echo "COS S3 Secret KEY:" "${tmp//?/*}"
# S3 Bucket name
echo "Bucket:" $S3_BUCKET
# S3 COS uri
echo "COS_URI:" $COS_URI
# NGINX location / or like /test/
echo "NGINX_LOCATION:" $NGINX_LOCATION

if [ -z "$NGINX_LOCATION" ] || [ -z "$COS_ENDPOINT" ] || [ -z "$COS_URI" ] || [ -z "$S3_ACCESS_KEY" ] || [ -z "$S3_SECRET_KEY" ] || [ -z "$S3_BUCKET" ]; then
    echo "Variables not set exiting"
    exit;
fi

# this are the only variables I need to replace with sed
# otherwise I would need to set a public DNS resolver which is a security issue
# see https://stackoverflow.com/questions/17685674/nginx-proxy-pass-with-remote-addr
sed -i "s,@COS_URI@,${COS_URI},g" /usr/local/openresty/nginx/conf/nginx.conf
# and location makes no sense in my case to use Variables
sed -i "s,@NGINX_LOCATION@,${NGINX_LOCATION},g" /usr/local/openresty/nginx/conf/nginx.conf

cat /usr/local/openresty/nginx/conf/nginx.conf

nginx -g 'daemon off;'
