FROM node:9.4
RUN mkdir -p /app
WORKDIR /app
COPY ./mynodejsproject/package.json /app/
RUN npm install
COPY ./mynodejsproject /app/
CMD ["node","index.js"]
