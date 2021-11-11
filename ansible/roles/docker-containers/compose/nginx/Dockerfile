# Set base image (host OS)
FROM nginx:alpine

# Set one or more individual labels
LABEL version="0.0.1-beta"
LABEL author="muutttu@live.fi"

RUN cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
COPY ./templates/nginx.conf.j2 /etc/nginx/nginx.conf