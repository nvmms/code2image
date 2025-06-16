FROM alpine:3.16

# 安装必要工具 (包含 SSH)
RUN apk add --no-cache \
    git \
    docker-cli \
    bash \
    openssh-client

WORKDIR /build

COPY build.sh /usr/local/bin/build-image
RUN chmod +x /usr/local/bin/build-image

ENTRYPOINT ["build-image"]