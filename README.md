#Docker image for Silverstripe

Add a `docker-compose.yml` file in your project and add the following:

```
version: '3.1'

services:
  web:
    image: voyagestudio/silverstripe-web:5.6
    ports:
      - '8080:80'
    links:
      - db
    volumes:
      - '.:/var/www/html'
```
