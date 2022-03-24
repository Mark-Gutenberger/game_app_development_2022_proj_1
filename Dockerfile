# syntax=docker/dockerfile:1

# SPDX-License-Identifier: MIT
# Author: Mark Gutenberger <mark-gutenberger@outlook.com>
# Dockerfile (c) 2022
# Desc: description
# Created:  2022-03-24T01:47:48.378Z
# Modified: 2022-03-24T02:42:04.998Z

FROM node:12.18.1
ENV NODE_ENV=production

WORKDIR /

COPY ["./", "./"]

RUN yarn install --ignore-engines
RUN yarn global add nodemon

COPY . .

CMD ["yarn", "dev"]

EXPOSE 3000
