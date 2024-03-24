# syntax=docker/dockerfile:1.4

# 1. For build React app
#base image secilip daha sonra development ortamı olduğu belirtiliyor
FROM node:lts AS development

# Set working directory
WORKDIR /app

# container icerisine kopyalama
COPY package.json /app/package.json
COPY package.lock.json /app/package-lock.json


# Same as npm install
RUN npm ci

COPY . /app

#NPM config için ENV tanımlanır.
ENV CI=true

CMD ["npm","start"]

#yukaridaki adımları tekrar yazmamak adina bir sonraki imajda devam ettiriyoruz
FROM development AS build

#build islemini gereceklestirme
RUN npm run build

#dev-ens icin bir katman daha eklendi
FROM development as dev-ens
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF


RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF

#install docker tools icin buildx, compose
COPY --from=gloursdocker/docker / /
CMD ["npm","start"]


# 2. for Nginx setup
FROM nginx:alpine

#copy config nginx
COPY --from=build /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

#remove default nginx static assets
RUN rm -rf ./*

#copy static assets from builder stage
COPY --from=build /app/build .

#containers run nginx with global and daemon off
ENTRYPOINT [ "nginx","-g","daemon off;" ]