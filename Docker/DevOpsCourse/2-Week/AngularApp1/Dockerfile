#Node.js image cekiliyor
FROM node
# default path belirlendi
WORKDIR /app
# json dosyalari default path'e kopyalandi
COPY package*.json ./
# Angular kurulumu
RUN npm install -g @angular/cli
# dependencies kurulumları
RUN npm install -g npm@10.5.0

RUN npm i
# Angular uygulama dosyalarinin kopyalanmasi
COPY . .
# port belirleme
EXPOSE 4200
# Uygulamanin baslatilmasi
CMD ["ng", "serve", "--host", "0.0.0.0"]
