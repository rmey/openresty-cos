#!/bin/sh
source ./env.local
echo "build OpenResty Image"
echo ${namespace}
image1=${namespace}/openresty-cos
docker build -t $image1 ./docker
docker push $image1
