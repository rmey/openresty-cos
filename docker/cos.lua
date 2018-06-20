-- resty.cos
-- Lua Module to access IBM Cloud Object Storage COS in NGINX/Openresty with HMAC signatures
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

function set_header(host, bucket, uri, http_method, access_key, secret_key)
  local region = 'us-standard'
  local endpoint = 'https://' .. host
  local bucket = bucket
  -- https://stackoverflow.com/questions/9084969/nginx-request-uri-without-args
  local object_key = string.gsub(uri, "?.*", "")
  local request_parameters = ''
  -- assemble the standardized request
  local microtime = ngx.time()
  local timestamp = os.date('!%Y%m%dT%H%M%SZ', microtime)
  local datestamp = os.date('!%Y%m%d', microtime)
  local standardized_resource = bucket .. object_key
  local standardized_querystring = request_parameters
  local standardized_headers = 'host:' .. host .. '\n' .. 'x-amz-date:' .. timestamp .. '\n'
  local signed_headers = 'host;x-amz-date'
  local payload_hash = str.to_hex(hashme(''))
  local standardized_request = http_method .. '\n' .. standardized_resource .. '\n' .. standardized_querystring .. '\n' .. standardized_headers .. '\n' .. signed_headers .. '\n' .. payload_hash
  -- assemble string-to-sign
  local hashing_algorithm = 'AWS4-HMAC-SHA256'
  local credential_scope = datestamp .. '/' .. region .. '/' .. 's3' .. '/' .. 'aws4_request'
  local sts = hashing_algorithm .. '\n' .. timestamp .. '\n' .. credential_scope .. '\n' .. str.to_hex(hashme(standardized_request))
  -- generate the signature
  local signature_key = createSignatureKey(secret_key, datestamp, region, 's3')
  local signature = str.to_hex(hmacme(signature_key,sts))
  -- assemble all elements into the 'authorization' header
  v4auth_header = hashing_algorithm .. ' ' .. 'Credential=' .. access_key .. '/' .. credential_scope .. ', ' .. 'SignedHeaders=' .. signed_headers .. ', ' .. 'Signature=' .. signature
  -- set header
  ngx.req.set_header('Authorization', v4auth_header)
  ngx.req.set_header('X-Amz-Date', timestamp)
end

_M.set_header = set_header
return _M
