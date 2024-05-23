## Dockerfile
```bash
# pull the node image
FROM node:14

# set the working directory
WORKDIR /app

# copy the package.json file
COPY package*.json ./

# install the dependencies
RUN npm install

# build the app
COPY . .

# expose port 3000
EXPOSE 3000

# start the app
CMD ["npm", "start"]
```
## docker-compose.yml
```yml
version: '3.1'
services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: web_app
    image: web_app
    ports:
      - "3000:3000"  
```
