FROM node AS builder

WORKDIR /run/app/front

COPY package*.json ./

RUN npm i

COPY ./src ./src
COPY ./public ./public

RUN npm run build

FROM httpd

EXPOSE 80

COPY --from=builder /run/app/front/build/ /usr/local/apache2/htdocs/