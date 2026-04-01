FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/prazzon/Flexbox-Labs.git && \
    cd Flexbox-Labs && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git && \
    sed -i '/const nextConfig/a\   output: "export",' next.config.ts

FROM --platform=$BUILDPLATFORM oven/bun:alpine AS build

WORKDIR /Flexbox-Labs
COPY --from=base /git/Flexbox-Labs .
RUN bun ci && \
    bun run build

FROM joseluisq/static-web-server

COPY --from=build /Flexbox-Labs/out ./public
