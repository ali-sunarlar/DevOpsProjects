FROM alpine:3.7 AS build
RUN apk update && apk add --update alpine-sdk
RUN mkdir /app
WORKDIR /app
COPY ./helloworld /app/
RUN mkdir bin
RUN gcc merhaba.c -o bin/merhaba

FROM alpine:3.7
COPY --from=build /app/bin/merhaba /app/merhaba
CMD /app/merhaba