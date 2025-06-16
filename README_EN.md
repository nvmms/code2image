# Code2Image

Code2Image is a tool for automating Docker image builds. It can clone code from Git repositories and build Docker images with various customization options.

## Features

- Clone code from Git repositories
- Support for specific branches and commits
- Automatic Docker image building
- Custom Dockerfile path support
- Push images to Docker Registry
- Support for additional tags
- Support for remote Docker hosts

## Usage

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| GIT_REPO | Yes | Git repository URL |
| IMAGE_TAG | Yes | Docker image tag to build |
| GIT_BRANCH | No | Git branch name |
| GIT_COMMIT | No | Specific Git commit hash |
| DOCKERFILE_PATH | No | Path to Dockerfile (relative to repository root) |
| DOCKER_BUILD_ARGS | No | Additional arguments for docker build |
| DOCKER_USERNAME | No | Docker Registry username (for pushing images) |
| DOCKER_PASSWORD | No | Docker Registry password (for pushing images) |
| EXTRA_TAGS | No | Additional image tags (space-separated) |
| DOCKER_HOST | No | Remote Docker host address (e.g., tcp://remote-docker:2375) |

### Usage Examples

1. Basic Usage (Public Repository):
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GIT_REPO=https://github.com/user/repo.git \
  -e IMAGE_TAG=my-app:latest \
  code2image
```

2. Using Remote Docker Host:
```bash
docker run --rm \
  -e DOCKER_HOST=tcp://remote-docker:2375 \
  -e GIT_REPO=https://github.com/user/repo.git \
  -e IMAGE_TAG=myapp:latest \
  code2image
```

3. Using Git Token (Private Repository):
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GIT_REPO=https://oauth2:YOUR_TOKEN@gitlab.com/user/repo.git \
  -e IMAGE_TAG=private-repo:1.0 \
  code2image
```

4. Complete Options Example:
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

## Notes

1. Docker socket must be mounted or DOCKER_HOST environment variable must be set
2. Ensure sufficient permissions to access Docker daemon
3. Provide correct authentication information for private repositories
4. For private Git repositories, use Git Token or SSH keys for authentication
5. In production environments, use Docker Registry access tokens instead of passwords
6. When using remote Docker host, ensure network connectivity and host accessibility

## Building

```bash
docker build -t code2image .
```
