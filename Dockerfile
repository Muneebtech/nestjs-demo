FROM node:18.13-alpine as builder

ENV NODE_ENV build

WORKDIR /usr/src/app

COPY . /usr/src/app/

RUN npm ci \ 
  && npm run build \ 
  && npm prune --production


FROM node:18.13-alpine

ENV NODE_ENV production

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/package*.json /usr/src/app/
COPY --from=builder /usr/src/app/node_modules /usr/src/app/node_modules/
COPY --from=builder /usr/src/app/dist /usr/src/app/dist/

CMD [ "node","dist/src/main.js" ]
