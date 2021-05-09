# build stage
FROM node:lts-alpine as build-stage

RUN apk update && \
    apk add git

WORKDIR /app

COPY package*.json ./
RUN yarn install
COPY .env.example .env
COPY . .
RUN yarn run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]