FROM openresty/openresty:alpine
WORKDIR /app
RUN mkdir -p resty && apk update && apk add perl curl libressl-dev && opm install jkeys089/lua-resty-hmac
COPY run.sh .
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY cos.lua resty/cos.lua
EXPOSE 8080
CMD ["./run.sh"]
