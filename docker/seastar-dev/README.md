# nv-dev
[![Build Docker - seastar-dev](https://github.com/wangyoucao577/containers/actions/workflows/autobuild-seastar-dev.yml/badge.svg)](https://github.com/wangyoucao577/containers/actions/workflows/autobuild-seastar-dev.yml)       
Image based on `ghcr.io/wangyoucao577/seastar/seastar-dev` which build from [wangyoucao577/seastar](https://github.com/wangyoucao577/seastar) for my seastar related development.     

## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/seastar-dev
$ docker build -t wangyoucao577/seastar-dev .  
```

## Pull Image 

### Github Container Registry
[Github Container Repo: wangyoucao577/seastar-dev](https://github.com/users/wangyoucao577/packages/container/package/seastar-dev)  
```bash
$ docker pull ghcr.io/wangyoucao577/seastar-dev
```

## Run container

```bash
$ docker run -d --restart=always --network=host --name="seastar-dev" --hostname="seastar-dev" --cap-add=ALL --security-opt seccomp=unconfined --privileged wangyoucao577/seastar-dev
```

## Author
wangyoucao577@gmail.com
