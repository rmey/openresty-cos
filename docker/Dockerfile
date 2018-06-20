FROM openresty/openresty:1.13.6.2-0-alpine
WORKDIR /app
RUN mkdir -p resty && apk update && apk add perl curl && opm install jkeys089/lua-resty-hmac && apk del perl curl
COPY run.sh .
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY cos.lua resty/cos.lua
EXPOSE 8080
CMD ["./run.sh"]
