FROM nginx:1.17.1-alpine
RUN addgroup -S skynet && \
    adduser -u 1001 -S skynet -G skynet && \
    mkdir /app && \
    touch /var/run/nginx.pid && \
    chown -R  skynet:skynet \
    /app \
    /etc/nginx/ \
    /var/cache/nginx \
    /var/run/nginx.pid
USER skynet
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./homework.html /app/homework.html
EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]