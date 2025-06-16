#!/bin/bash

set -eo pipefail

# 验证 Docker 连接
if [ -S "/var/run/docker.sock" ]; then
    export DOCKER_HOST=unix:///var/run/docker.sock
elif [ -n "$DOCKER_HOST" ]; then
    echo "使用指定的 DOCKER_HOST: $DOCKER_HOST"
else
    echo "错误: 需要挂载 /var/run/docker.sock 或设置 DOCKER_HOST"
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "错误: 无法连接到 Docker 守护进程"
    exit 1
fi

# 必需参数检查
[ -z "$GIT_REPO" ] && { echo "错误: 必须设置 GIT_REPO"; exit 1; }
[ -z "$IMAGE_TAG" ] && { echo "错误: 必须设置 IMAGE_TAG"; exit 1; }

# 设置 SSH 配置
if [ -d "/root/.ssh" ]; then
    echo "检测到 SSH 公钥，设置 SSH 配置..."
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/*
fi

# 克隆仓库
echo "正在克隆仓库: $GIT_REPO"
if [ -n "$GIT_BRANCH" ]; then
    CLONE_CMD="git clone --branch $GIT_BRANCH $GIT_REPO src"
else
    CLONE_CMD="git clone $GIT_REPO src"
fi

if ! eval "$CLONE_CMD"; then
    echo "错误: 仓库克隆失败"
    exit 1
fi

cd src || exit 1

# 检出特定提交（如果指定）
if [ -n "$GIT_COMMIT" ]; then
    echo "检出提交: $GIT_COMMIT"
    git checkout "$GIT_COMMIT" || exit 1
fi

# 构建镜像
echo "正在构建镜像: $IMAGE_TAG"
BUILD_CMD="docker build"
[ -n "$DOCKERFILE_PATH" ] && BUILD_CMD="$BUILD_CMD -f $DOCKERFILE_PATH"
[ -n "$DOCKER_BUILD_ARGS" ] && BUILD_CMD="$BUILD_CMD $DOCKER_BUILD_ARGS"
BUILD_CMD="$BUILD_CMD -t $IMAGE_TAG ."

echo "执行命令: $BUILD_CMD"
eval "$BUILD_CMD" || exit 1

# 推送镜像（如果提供凭证）
if [ -n "$DOCKER_USERNAME" ] && [ -n "$DOCKER_PASSWORD" ]; then
    echo "登录到 Docker Registry"
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || exit 1
    
    echo "推送镜像..."
    docker push "$IMAGE_TAG" || exit 1
    
    # 推送额外标签
    if [ -n "$EXTRA_TAGS" ]; then
        for tag in $EXTRA_TAGS; do
            echo "添加标签: $tag"
            docker tag "$IMAGE_TAG" "$tag"
            docker push "$tag" || exit 1
        done
    fi
fi

echo "构建完成: $IMAGE_TAG"