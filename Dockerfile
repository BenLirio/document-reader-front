FROM node AS builder
WORKDIR /run/app/front
COPY package*.json ./
RUN npm i
COPY ./src ./src
COPY ./public ./public
RUN npm run build

FROM node AS dev
WORKDIR /run/app/front
COPY package*.json ./
RUN npm i
COPY ./src ./src
COPY ./public ./public
ENTRYPOINT ["npm", "run", "start"]

FROM nginx:alpine AS nginx
COPY --from=builder /run/app/front/build/ /usr/share/nginx/html
# Not sure how this works but lets me use a env port
ADD ./nginx/default.conf /etc/nginx/conf.d/default.template
CMD sh -c "envsubst \"`env | awk -F = '{printf \" \\\\$%s\", $1}'`\" < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"