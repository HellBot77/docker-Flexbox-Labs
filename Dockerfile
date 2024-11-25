FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/prazzon/Flexbox-Labs.git && \
    cd Flexbox-Labs && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /Flexbox-Labs
COPY --from=base /git/Flexbox-Labs .
RUN npm install && \
    npm run build

FROM lipanski/docker-static-website

COPY --from=build /Flexbox-Labs/dist .
