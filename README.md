# openresty-cos
Example OpenResty Docker/Kubernetes example to access and cache private elements in IBM Cloud Object Storage with AWS Signature Version 4 support

Prerequisites:
* Free or paid IBM Cloud Kubernetes Custer
* IBM Cloud Object Storage Instance with bucket and HMAC credentials
https://console.bluemix.net/docs/services/cloud-object-storage/hmac/credentials.html#using-hmac-credentials
* s3cmd installed,  separate configuration not needed, everything needed will be passed by 1_s3sync.sh script
http://s3tools.org/s3cmd


1. copy env.local.sample to env.local
2. adjust settings in env.local to match your COS and Kubernetes Settings
3. execute 01_s3sync this will copy the wwwroot example page to your bucket
4. execute 02_buildimages.sh this will build the Docker image and push to IBM Cloud Container Registry Service
5. execute 03_deploy.sh this will generate a deploy2kube.yaml
6. kubect create -f deploy2kube.yaml
7. curl -I http://YOURWORKERNODEIP:31200/index.html  output will contain X-Cache: MISS
8. run again curl -I http://YOURWORKERNODEIP:31200/index.html  output will contain X-Cache: HIT

TODO:
1. Build Helmchart
2. Document example
