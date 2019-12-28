# openresty-cos
Example OpenResty Docker/Kubernetes example to access and cache private elements in IBM Cloud Object Storage with AWS Signature Version 4 support

Prerequisites:
* Free or paid IBM Cloud Kubernetes Custer
* IBM Cloud Object Storage Instance with bucket and HMAC credentials
https://console.bluemix.net/docs/services/cloud-object-storage/hmac/credentials.html#using-hmac-credentials
* s3cmd installed,  separate configuration not needed, everything needed will be passed by 01_s3sync.sh script
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

---

## Alternative Openresty-COS deployment with Cloudfoundry/Docker

CloudFoundry/Docker example to access and cache private elements in IBM Cloud Object Storage with AWS Signature Version 4 support

Prerequisites:

* IBM Cloud Account

* Private IBM Cloud Container Registry namespace for docker container <https://console.bluemix.net/docs/services/Registry/index.html#registry_namespace_add>

* IBM Cloud Object Storage Instance with bucket and HMAC credentials <https://console.bluemix.net/docs/services/cloud-object-storage/hmac/credentials.html#using-hmac-credentials>

* s3cmd installed, separate configuration not needed, everything needed will be passed by 01_s3sync.sh script <http://s3tools.org/s3cmd>

Setup:

1. copy env.local.sample to env.local
2. adjust settings in env.local to match your COS and Container Registry namespace
3. execute `./01_s3sync.sh` this will copy the wwwroot example page to your bucket
4. execute `./02_buildimages.sh` this will build the Docker image and push to IBM Cloud Container Registry Service
5. execute `./04_manifest_cf.sh` this will create a Cloud Foundry manifest.yaml to deploy your private openresty-cos docker-image
6. execute `CF_DOCKER_PASSWORD=$(ibmcloud cr token-add -q) ibmcloud cf push APP_NAME` (**APP_NAME** must be unique)
7. open https://**APP_NAME**.mybluemix.net/index.html in your browser _**NOTE**: keep in mind that each IBM Cloud region has it's own domain. To display your app's route execute: `ibmcloud cf app APP_NAME | grep routes`_
