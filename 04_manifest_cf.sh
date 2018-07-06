#!/bin/sh

source ./env.local

###################################################
# prepare your container as cloud foundry app     #
###################################################
cp manifest.template manifest.yaml
# replacements with sed using , syntax because we have slahes in url
sed -i '' "s,@REGISTRY@,${namespace},g" manifest.yaml
sed -i '' "s,@S3_ACCESS_KEY@,${S3_ACCESS_KEY},g" manifest.yaml
sed -i '' "s,@S3_SECRET_KEY@,${S3_SECRET_KEY},g" manifest.yaml
sed -i '' "s,@S3_BUCKET@,${S3_BUCKET},g" manifest.yaml
sed -i '' "s,@COS_ENDPOINT@,${COS_ENDPOINT},g" manifest.yaml
sed -i '' "s,@COS_URI@,${COS_URI},g" manifest.yaml
sed -i '' "s,@NGINX_LOCATION@,${NGINX_LOCATION},g" manifest.yaml