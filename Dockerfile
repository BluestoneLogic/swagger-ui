# Looking for information on environment variables?
# We don't declare them here — take a look at our docs.
# https://github.com/swagger-api/swagger-ui/blob/master/docs/usage/configuration.md

FROM centos:7
LABEL maintainer="jlevin"

COPY ./docker/run.sh /

RUN yum install epel-release -y \
	&& yum install nginx -y \
	&& yum install nodejs -y \
	&& yum clean all -y

ENV API_KEY "**None**"
ENV SWAGGER_JSON "/app/swagger.json"
ENV PORT 8080
ENV BASE_URL ""

COPY ./docker/nginx.conf ./docker/cors.conf /etc/nginx/

# copy swagger files to the `/js` folder
COPY ./dist/* /usr/share/nginx/html/
# COPY ./docker/run.sh /usr/share/nginx/
COPY ./docker/configurator /usr/share/nginx/configurator

RUN ls -al /usr/share/nginx/html

RUN chmod +x /run.sh

RUN chown -R 1001:0 /usr/share/nginx/configurator \
	&& chown -R 1001:0 /usr/share/nginx/html \
	&& chown -R 1001:0 /var/lib/nginx \
	&& chown -R 1001:0 /etc/nginx \
	&& chown -R 1001:0 run.sh \
	&& chown -R 1001:0 /run \
	&& chmod -R g=u /usr/share/nginx/configurator
	&& chmod -R g=u /usr/share/nginx/html \
	&& chmod -R g=u /var/lib/nginx \
	&& chmod -R g=u /etc/nginx \
	&& chmod -R g=u run.sh \
	&& chmod -R g=u /run

RUN touch /var/log/nginx/error.log \
    && touch /var/log/nginx/access.log \
    && chown -R 1001:0 /var/log/nginx \
    && chown -R 1001:0 /var/log/nginx \
    && chown -R 1001:0 /var/log/nginx/error.log \
    && chown -R 1001:0 /var/log/nginx/access.log \
    && chmod -R g=u /var/log/nginx \
    && chmod -R g=u /var/log/nginx \
    && chmod -R g=u /var/log/nginx/error.log \
    && chmod -R g=u /var/log/nginx/access.log

RUN chmod g=u /etc/passwd


EXPOSE 8080

USER 1001

CMD ["sh", "/run.sh"]
