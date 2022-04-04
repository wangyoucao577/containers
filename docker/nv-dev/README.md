# nv-dev
[![Build Docker - nv-dev](https://github.com/wangyoucao577/containers/actions/workflows/autobuild-nv-dev.yml/badge.svg)](https://github.com/wangyoucao577/containers/actions/workflows/autobuild-nv-dev.yml)        
Image based on `nvidia/cuda` for my CUDA related development.     

## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/nv-dev
$ docker build -t wangyoucao577/nv-dev .  
```

## Pull Image 
### DockerHub
[DockerHub Repo: wangyoucao577/nv-dev](https://hub.docker.com/r/wangyoucao577/nv-dev)    
```bash
$ docker pull wangyoucao577/nv-dev
```

### Github Container Registry
[Github Container Repo: wangyoucao577/nv-dev](https://github.com/users/wangyoucao577/packages/container/package/nv-dev)
```bash
$ docker pull ghcr.io/wangyoucao577/nv-dev
```

## Run container

```bash
$ docker run -d --restart=always -p 13171:22 --name="nv-dev" --hostname="nv-dev" --cap-add=ALL --security-opt seccomp=unconfined --privileged --gpus all wangyoucao577/nv-dev
4dce06ca751f4ee803df809396b8e1ed830f496ed530f52476034a92d35c8fe2
```

## Author
wangyoucao577@gmail.com
