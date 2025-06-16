# Code2Image

Code2Image 是一个用于自动化构建 Docker 镜像的工具。它可以从 Git 仓库克隆代码并构建 Docker 镜像，支持多种自定义选项。

## 功能特点

- 从 Git 仓库克隆代码
- 支持指定分支和提交
- 自动构建 Docker 镜像
- 支持自定义 Dockerfile 路径
- 支持推送镜像到 Docker Registry
- 支持添加额外标签
- 支持远程 Docker 主机

## 使用方法

### 环境变量

| 变量名 | 必填 | 描述 |
|--------|------|------|
| GIT_REPO | 是 | Git 仓库地址 |
| IMAGE_TAG | 是 | 要构建的镜像标签 |
| GIT_BRANCH | 否 | Git 分支名称 |
| GIT_COMMIT | 否 | 特定的 Git 提交哈希 |
| DOCKERFILE_PATH | 否 | Dockerfile 的路径（相对于仓库根目录） |
| DOCKER_BUILD_ARGS | 否 | 传递给 docker build 的额外参数 |
| DOCKER_USERNAME | 否 | Docker Registry 用户名（用于推送镜像） |
| DOCKER_PASSWORD | 否 | Docker Registry 密码（用于推送镜像） |
| EXTRA_TAGS | 否 | 额外的镜像标签（空格分隔） |
| DOCKER_HOST | 否 | 远程 Docker 主机地址（例如：tcp://remote-docker:2375） |

### 使用示例

1. 基础使用（公开仓库）：
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GIT_REPO=https://github.com/user/repo.git \
  -e IMAGE_TAG=my-app:latest \
  code2image
```

2. 使用远程 Docker 主机：
```bash
docker run --rm \
  -e DOCKER_HOST=tcp://remote-docker:2375 \
  -e GIT_REPO=https://github.com/user/repo.git \
  -e IMAGE_TAG=myapp:latest \
  code2image
```

3. 使用 Git Token（私有仓库）：
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GIT_REPO=https://oauth2:YOUR_TOKEN@gitlab.com/user/repo.git \
  -e IMAGE_TAG=private-repo:1.0 \
  code2image
```

4. 完整选项示例：
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GIT_REPO=https://github.com/user/repo.git \
  -e GIT_BRANCH=production \
  -e GIT_COMMIT=a1b2c3d4 \
  -e IMAGE_TAG=registry.example.com/app:2.1.0 \
  -e EXTRA_TAGS="registry.example.com/app:latest" \
  -e DOCKERFILE_PATH=./docker/Dockerfile.prod \
  -e DOCKER_BUILD_ARGS="--build-arg ENV=prod --no-cache" \
  -e DOCKER_USERNAME=ci-user \
  -e DOCKER_PASSWORD=secret-password \
  code2image
```

## 注意事项

1. 需要挂载 Docker socket 或设置 DOCKER_HOST 环境变量
2. 确保有足够的权限访问 Docker daemon
3. 如果使用私有仓库，请确保提供正确的认证信息
4. 对于私有 Git 仓库，可以使用 Git Token 或 SSH 密钥进行认证
5. 建议在生产环境中使用 Docker Registry 的访问令牌而不是密码
6. 使用远程 Docker 主机时，确保网络连接正常且主机可访问

## 构建

```bash
docker build -t code2image .
```
