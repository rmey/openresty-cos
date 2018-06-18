-- resty.cos
-- Module to access IBM Cloud Object Storage COS in NGINX/Openresty with HMAC signatures
-- conversion from the python example here
-- https://console.bluemix.net/docs/services/cloud-object-storage/hmac/hmac-signature.html#constructing-an-hmac-signature
local _M = { _VERSION = '0.1.0' }
local mt = { __index = _M }

local str = require "resty.string"
local hmac = require "resty.hmac"

function hmacme(key, msg)
  local hmac_sha256 = hmac:new(key, hmac.ALGOS.SHA256)
  hmac_sha256:update(msg)
  local mac = hmac_sha256:final()
  return mac
end

function hashme(msg)
  local resty_sha256 = require "resty.sha256"
  local sha256 = resty_sha256:new()
  sha256:update(msg)
  local digest = sha256:final()
  return digest
end

function createSignatureKey(key, datestamp, region, service)
    local keyDate = hmacme('AWS4' .. key, datestamp)
    local keyString = hmacme(keyDate, region)
    local keyService = hmacme(keyString, service)
    local keySigning = hmacme(keyService, 'aws4_request')
    return keySigning
end


function _M.set_iso_date(self, microtime)
  ngx.time()
  iso_date = os.date('!%Y%m%d', microtime)
  iso_tz   = os.date('!%Y%m%dT%H%M%SZ', microtime)
end

function set_header(host, bucket, uri, http_method, access_key, secret_key)
  --local mac = hashme('abc','Molch')
  ngx.log(ngx.INFO, host)
  ngx.log(ngx.INFO, bucket)
  ngx.log(ngx.INFO, uri)
  ngx.log(ngx.INFO, http_method)
  -- ngx.log(ngx.INFO, access_key)
  -- ngx.log(ngx.INFO, secret_key)
  local region = 'us-standard'
  local endpoint = 'https://' .. host
  ngx.log(ngx.INFO, endpoint)
  local bucket = bucket
  ngx.log(ngx.INFO, bucket)
  -- https://stackoverflow.com/questions/9084969/nginx-request-uri-without-args
  local object_key = string.gsub(uri, "?.*", "")
  ngx.log(ngx.INFO, object_key)
  local request_parameters = ''

  -- assemble the standardized request
  local microtime = ngx.time()
  local timestamp = os.date('!%Y%m%dT%H%M%SZ', microtime)
  local datestamp = os.date('!%Y%m%d', microtime)
  ngx.log(ngx.INFO, timestamp .. ' ' .. datestamp)
  local standardized_resource = bucket .. object_key
  ngx.log(ngx.INFO, standardized_resource)
  local standardized_querystring = request_parameters
  local standardized_headers = 'host:' .. host .. '\n' .. 'x-amz-date:' .. timestamp .. '\n'
  ngx.log(ngx.INFO, standardized_headers)
  local signed_headers = 'host;x-amz-date'
  ngx.log(ngx.INFO, signed_headers)
  local payload_hash = str.to_hex(hashme(''))
  ngx.log(ngx.INFO, payload_hash)
  local standardized_request = http_method .. '\n' .. standardized_resource .. '\n' .. standardized_querystring .. '\n' .. standardized_headers .. '\n' .. signed_headers .. '\n' .. payload_hash
  ngx.log(ngx.INFO, standardized_request)
  -- assemble string-to-sign
  local hashing_algorithm = 'AWS4-HMAC-SHA256'
  local credential_scope = datestamp .. '/' .. region .. '/' .. 's3' .. '/' .. 'aws4_request'
  local sts = hashing_algorithm .. '\n' .. timestamp .. '\n' .. credential_scope .. '\n' .. str.to_hex(hashme(standardized_request))
  ngx.log(ngx.INFO, sts)
  -- generate the signature
  local signature_key = createSignatureKey(secret_key, datestamp, region, 's3')
  local signature = str.to_hex(hmacme(signature_key,sts))
  ngx.log(ngx.INFO,signature)
  -- assemble all elements into the 'authorization' header
  v4auth_header = hashing_algorithm .. ' ' .. 'Credential=' .. access_key .. '/' .. credential_scope .. ', ' .. 'SignedHeaders=' .. signed_headers .. ', ' .. 'Signature=' .. signature
  ngx.log(ngx.INFO,v4auth_header)
  ngx.req.set_header('Authorization', v4auth_header)
  ngx.req.set_header('X-Amz-Date', timestamp)
end

_M.set_header = set_header
return _M
