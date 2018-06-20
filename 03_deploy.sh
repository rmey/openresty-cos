#!/bin/sh
# source env
source ./env.local
cp deploy2kube.template deploy2kube.yaml
# replacements with sed using , syntax because we have slahes in url
sed -i '' "s,@REGISTRY@,${namespace},g" deploy2kube.yaml
sed -i '' "s,@S3_ACCESS_KEY@,${S3_ACCESS_KEY},g" deploy2kube.yaml
sed -i '' "s,@S3_SECRET_KEY@,${S3_SECRET_KEY},g" deploy2kube.yaml
sed -i '' "s,@S3_BUCKET@,${S3_BUCKET},g" deploy2kube.yaml
sed -i '' "s,@COS_ENDPOINT@,${COS_ENDPOINT},g" deploy2kube.yaml
sed -i '' "s,@COS_URI@,${COS_URI},g" deploy2kube.yaml
sed -i '' "s,@NGINX_LOCATION@,${NGINX_LOCATION},g" deploy2kube.yaml
