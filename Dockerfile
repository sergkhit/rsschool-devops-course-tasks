# Create image based on the official Node 14 image from dockerhub
FROM node:14

# Create a directory where our app will be placed
RUN mkdir -p /app

# Change directory so that our commands run inside this new directory
WORKDIR /app

# Copy dependency definitions
COPY package*.json /app/

# Install dependecies
RUN npm install

# Get all the code needed to run the app
COPY . /app/

ARG APP_SERVER_PORT

ENV PORT $APP_SERVER_PORT

# Start the node server
# CMD ["npm", "run", "start:prod"]
CMD ["npm", "start"]

# # Use the official WordPress image
# FROM wordpress:5.9
# # Install dependencies
# COPY . /var/www/html