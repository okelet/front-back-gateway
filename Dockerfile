FROM nginx:alpine

COPY --chown=nginx:nginx templates/* /etc/nginx/templates/
COPY --chown=nginx:nginx certs/* /etc/nginx/certs/
COPY --chown=nginx:nginx custom-entrypoint.sh /
RUN chmod +x /custom-entrypoint.sh

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
