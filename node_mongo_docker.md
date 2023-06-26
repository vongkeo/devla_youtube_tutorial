```
MONGODB_USER=root
MONGODB_PASSWORD=123456
MONGODB_DATABASE=my_api
MONGODB_PORT=27017
```

```docker
# Use an official Node.js runtime as the base image
FROM node:16-alpine

# Set the working directory to /app
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install the dependencies
RUN npm install

# Install pm2 globally
RUN npm install pm2 -g

# Copy the remaining application files to the container
COPY . .

# Expose the port that the application listens on
EXPOSE 5918

# Start the application using pm2
CMD ["pm2-docker", "start", "process.json"]
```

```json
{
  "apps": [
    {
      "name": "my_docker_app",
      "script": "index.js",
      "args": [],
      "log_date_format": "YYYY-MM-DD HH:mm Z",
      "watch": false,
      "node_args": "",
      "merge_logs": false,
      "cwd": "./",
      "exec_mode": "cluster",
      "instances": "1",
      "env": {
        "NODE_ENV": "local"
      }
    }
  ]
}
```

```
version: "3.9"
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    env_file: ./.env
    ports:
      - 5918:5918
    environment:
      - APP_PORT=5918
      - DB_HOST=mongodb
      - DB_USER=$MONGODB_USER
      - DB_PASSWORD=$MONGODB_PASSWORD
      - DB_NAME=$MONGODB_DATABASE
      - DB_PORT=$MONGODB_PORT
    depends_on:
      - mongodb

  mongodb:
    image: mongo:4.4.6
    restart: unless-stopped
    ports:
      - 12345:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=$MONGODB_USER
      - MONGO_INITDB_ROOT_PASSWORD=$MONGODB_PASSWORD
volumes:
  node-mongo-data:
```

```
.dockerignore
node_modules
npm-debug.log
```
