FROM nginx:stable-alpine

# ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf
# ADD ./nginx/certs /etc/nginx/certs/self-signed

RUN mkdir -p /var/www/html

RUN addgroup docker && adduser --disabled-password --ingroup docker --no-create-home docker
RUN chmod o+r /etc/resolv.conf

RUN chown docker:docker /var/www/html
RUN chmod 777 /var/www/html
