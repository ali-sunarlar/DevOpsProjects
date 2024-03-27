FROM alpine:3.7
RUN apk update && apk add --update alpine-sdk
RUN mkdir /app
WORKDIR /app
COPY ./helloworld /app/
RUN mkdir bin
RUN gcc -Wall merhaba.c -o bin/merhaba
CMD /app/bin/merhaba