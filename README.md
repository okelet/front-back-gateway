# Frontend/Backend gateway

[![DockerHub pulls](https://img.shields.io/docker/pulls/okelet/front-back-gateway.svg)](https://hub.docker.com/repository/docker/okelet/front-back-gateway)

This Docker image is based on the [nginx](https://hub.docker.com/_/nginx) image, and configures automatically a gateway, that forwards requests to two backends, simulating the frontend/backend pattern. This image was created to simulate the behaviour of the [Spring Cloud Gateway](https://spring.io/projects/spring-cloud-gateway) image, for doing the initial infrastructure deployment, before the real software is deployed. I usually use the [mendhak/http-https-echo](https://hub.docker.com/r/mendhak/http-https-echo) or [containous/whoami](https://hub.docker.com/r/containous/whoami) images as the backend.

You can test it using this command:

```bash
docker run --rm -it \
    -p 8080:8080 -p 8443:8443 \
    -e FRONTEND_URL=https://httpbin.org/anything/frontend \
    -e BACKEND_URL=https://httpbin.org/anything/backend \
    okelet/front-back-gateway:1.0
```

Nginx will forward the requests according to this configuration:

* `/api/*` -> backend
* `/*` -> frontend

For example:

* <http://127.0.0.1:8080/api/hello> -> would return a JSON document, where the "url" field is <https://httpbin.org/anything/backend/api/hello>
* <http://127.0.0.1:8080/index.html> -> would return a JSON document, where the "url" field is <https://httpbin.org/anything/frontend/index.html>

You don't have to worry about invalid SSL certificates in the backends, as nginx, by default, doesn't check its validity when proxying the requests.

nginx is [configured to listen in the ports HTTP/8080 and HTTPS/8443](templates/nginx.conf.template) using a self signed certificate, valid for 10 years.

## Environment variables

* `BACKEND_URL` (mandatory): URL where requests under `/api` will be forwarded.
* `FRONTEND_URL` (mandatory): URL where requests not matching the previous route will be forwarded.
* `DNS_RESOLVER` (optional): nginx requires a DNS server to resolve the forwarded servers; if this value is not set, it will be guessed automatically from `/etc/resolv.conf`.

## Test using docker-compose

A [`docker-compose.yml`](docker-compose.yml) is included in the repo, so the image is easy to run and test.

```bash
docker-compose up -d                       # Start the containers
sleep 5                                    # Wait for containers to start
curl http://127.0.0.1:8080/index.html      # Returns Name: frontend, GET /index.html HTTP/1.1
curl http://127.0.0.1:8080/api/test        # Returns Name: backend, GET /api/test HTTP/1.1
docker-compose rm -sf                      # Stop and remove the containers
```

## Repositories

This image is available in the following repositories:

* [Docker Hub](https://hub.docker.com/repository/docker/okelet/front-back-gateway)
* [AWS Public ECR](https://gallery.ecr.aws/okelet/front-back-gateway)
* [GitHub Packages](https://github.com/okelet/front-back-gateway/pkgs/container/front-back-gateway)
