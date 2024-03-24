FROM nginx:latest
WORKDIR /usr/share/
COPY index.html .
COPY style.css css/
COPY script.js js/
CMD ["nginx", "-g","deamon off;"]