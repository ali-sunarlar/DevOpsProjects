#Öncelikli olarak image bilgisini yaziyoruz
FROM node:10-alpine
#Kullanicinin tanimlanmasi
USER node
#ilgili klasorlerin olsuturulmasi ve klasor yetkilerinin degisterilmesi
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
#default calisma dizini
WORKDIR /home/node/app
#json dosyalarinin kopyalanmasi
COPY ./NodejsWebApp1/NodejsWebApp1/package*.json ./
COPY ./NodejsWebApp1/NodejsWebApp1/server*.js ./
#Bagimliliklarinin container node_modules klasorune yuklenmesi
RUN npm install
#Yetkilerinin kopyalanmasi
COPY --chown=node:node . .

#Yayin yapilacak port
EXPOSE 8080

#Uygulamanin containerda calistirilmasi
CMD ["node","server.js"]