# Docker image for Silverstripe

## Supported tags

* [7.3](/7.3/Dockerfile)
* [7.1](/7.1/Dockerfile)
* [5.6](/5.6/Dockerfile)

## Getting Started

Add a `docker-compose.yml` file in your project and add the following:

```
version: '3'
services:
  web:
    image: voyagestudio/silverstripe-web:7.3
    ports:
      - "8080:80"
    working_dir: /var/www
    volumes:
      - .:/var/www/html
    environment:
      DEVSERVER_HOST: "${DEVSERVER_HOST}"
      DEVSERVER_PORT: "${DEVSERVER_PORT}"

  db:
    image: mysql:5
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    volumes:
      - db-data:/var/lib/mysql
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=true

volumes:
  db-data:

```
