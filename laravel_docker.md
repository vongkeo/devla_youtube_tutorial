## Running Laravel with Docker

### Dockerfile
```bash
FROM php:8.2-fpm

# Install the required packages
RUN apt update && apt install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev

# clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# install php extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# set working directory
WORKDIR /var/www

# copy the project files
COPY . .

# expose port 9000
EXPOSE 9000

# start the php-fpm server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"]
```

### docker-compose.yml
```yml
version: '3.8'

services:
  my-app:
    build:
      context: ./
      dockerfile: Dockerfile
    container_name: my-app
    image: my-app
    restart: unless-stopped
    ports:
      - "9000:9000"
    networks:
      - my-network

networks:
  my-network:
    driver: bridge
```


