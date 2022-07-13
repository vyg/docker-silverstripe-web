# Docker image for Silverstripe

## Supported tags

- [`8.1`](/8.1/Dockerfile)
- [`7.4`, `latest`](/7.4/Dockerfile)
- [`7.4-sspak`](/7.4-sspak/Dockerfile) 7.4 but with built-in SSPAK
- [`7.3`](/7.3/Dockerfile)
- [`7.1`](/7.1/Dockerfile)
- [`5.6`](/5.6/Dockerfile)

## Getting Started

Add a `docker-compose.yml` file in your project and add the following:

```
version: '3'
services:
  web:
    image: voyagestudio/silverstripe-web:<tag>
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

### Building Docker Images

To rebuild and publish on Docker hub make sure you are logged in on your local machine

In `build.sh`, include the version you have just created, in `phpVersions` array.
Run the following `sh build.sh --run --push` to build and push the tags for each image.
