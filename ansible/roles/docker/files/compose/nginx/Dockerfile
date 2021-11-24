# Container base image (host OS)
FROM nginx:latest

# Labels for container
LABEL version="0.0.1-beta"
LABEL author="muutttu"

# create the public html folder for future use
RUN mkdir -p /var/www/public
# create /var/www/certbott folder (volume: certbot_conf)
RUN mkdir -p /var/www/certbot

# Add new default nginx conf to container
COPY ./templates/nginx.conf /etc/nginx/nginx.conf
# Add new html test template to container
COPY ./files/index.html /usr/share/nginx/html/index.html
# Create PID file
RUN touch /var/run/nginx.pid

# Using compose environment variables for default.conf file
#ADD ./templates/default.conf.template /etc/nginx/conf.d/default.conf
COPY ./templates/default.conf.template /etc/nginx/templates/default.conf.template