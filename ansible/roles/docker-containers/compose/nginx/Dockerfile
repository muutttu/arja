# Container base image (host OS)
FROM nginx:alpine

# Labels for container
LABEL version="0.0.1-beta"
LABEL author="muutttu@live.fi"

# backup copy for nginx.conf file
RUN cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
# removing default nginx config file
RUN rm /etc/nginx/conf.d/default.conf
# copying own config to nginx container
COPY ./templates/nginx.conf.j2 /etc/nginx/nginx.conf