FROM node:19.9.0-alpine3.17
WORKDIR '/app'
COPY package.json .
RUN yarn
COPY . .
EXPOSE 3000
CMD ["node", "index.js"]