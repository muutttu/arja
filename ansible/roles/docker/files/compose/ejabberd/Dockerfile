## ECS config start ##
# Container base image (host OS)
#FROM ejabberd/ecs:latest

# Labels for container
#LABEL version="0.0.1-beta"
#LABEL author="muutttu"

# https://warlord0blog.wordpress.com/2021/01/23/ejabberd-and-ca-certificates/
#USER root
#RUN apk add ca-certificates

# create ssl folder for certbot/letsencrypt certs
#USER ejabberd
# TODO: miten lukuoikeus, jos volumen tiedostot root:root, ja ejabberd tarttee ejabberd:ejabberd ?
#RUN mkdir -p /home/ejabberd/certbot


# backup copy for conf file # TODO, miten onnistuu, kun conf-kansio on volume?
#RUN cp /home/ejabberd/conf/ejabberd.yml /home/ejabberd/conf/ejabberd.yml.bak
# copying own config to container # TODO, miten onnistuu, kun conf-kansio on volume?
#COPY ./templates/ejabberd.yml /home/ejabberd/conf/ejabberd.yml
## ECS config end ##


##  rroemhild/docker-ejabberd  config start ##
FROM rroemhild/ejabberd:latest

# Labels for container
LABEL version="0.0.1-beta"
LABEL author="muutttu"

ADD ./templates/ejabberd.yml.tpl /opt/ejabberd/conf/ejabberd.yml.tpl
#ADD ./templates/ejabberdctl.cfg.tpl /opt/ejabberd/conf/ejabberdctl.cfg.tpl
#ADD ./templates/example.com.pem /opt/ejabberd/ssl/example.com.pem

# Create log files
RUN touch /usr/local/var/log/ejabberd/crash.log
RUN touch /usr/local/var/log/ejabberd/error.log
RUN touch /usr/local/var/log/ejabberd/erlang.log