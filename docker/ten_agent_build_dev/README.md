# ten_agent_build_dev
[![Build Docker - ten_agent_build_dev](https://github.com/wangyoucao577/containers/actions/workflows/autobuild-ten_agent_build_dev.yml/badge.svg)](https://github.com/wangyoucao577/containers/actions/workflows/autobuild-ten_agent_build_dev.yml)        
Image based on `ghcr.io/ten-framework/ten_agent_build` for my ten framework/agent development.     

## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/ten_agent_build_dev
$ docker build -t wangyoucao577/ten_agent_build_dev .  
```

## Pull Image 
### DockerHub
[DockerHub Repo: wangyoucao577/ten_agent_build_dev](https://hub.docker.com/r/wangyoucao577/ten_agent_build_dev)    
```bash
$ docker pull wangyoucao577/ten_agent_build_dev
```

### Github Container Registry
[Github Container Repo: wangyoucao577/ten_agent_build_dev](https://github.com/users/wangyoucao577/packages/container/package/ten_agent_build_dev)
```bash
$ docker pull ghcr.io/wangyoucao577/ten_agent_build_dev
```

## Run container

```bash
$ docker run -d --restart=always -p 13171:13171 --name="ten_agent_build_dev" --hostname="ten_agent_build_dev" --cap-add=ALL --security-opt seccomp=unconfined --privileged --shm-size 64g  wangyoucao577/ten_agent_build_dev
```

## Author
wangyoucao577@gmail.com
