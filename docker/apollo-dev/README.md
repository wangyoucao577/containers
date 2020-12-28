# apollo-dev
![Build Docker - apollo-dev](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20apollo-dev/badge.svg)      
Dev image based on `ubuntu:focal` to support my playing on [ApolloAuto/apollo](https://github.com/ApolloAuto/apollo).      

## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/apollo-dev
$ docker build -t wangyoucao577/apollo-dev .  
```

## Pull Image 
### DockerHub
[DockerHub Repo: wangyoucao577/apollo-dev](https://hub.docker.com/r/wangyoucao577/apollo-dev)    
```bash
$ docker pull wangyoucao577/apollo-dev
```

### Github Container Registry
[Github Container Repo: wangyoucao577/apollo-dev](https://github.com/users/wangyoucao577/packages/container/package/apollo-dev)
```bash
$ docker pull ghcr.io/wangyoucao577/apollo-dev
```

### Github Package
[Github Package Repo: docker.pkg.github.com/wangyoucao577/containers/apollo-dev](https://github.com/wangyoucao577/containers/packages/553409)

```bash
$ docker pull docker.pkg.github.com/wangyoucao577/containers/apollo-dev
```


## Run container

```bash
$ docker run -d --restart=always -p 13191:22 --privileged --cap-add=ALL --security-opt seccomp=unconfined wangyoucao577/apollo-dev
4dce06ca751f4ee803df809396b8e1ed830f496ed530f52476034a92d35c8fe2
```

### Init commands after entered into container

```bash
# enable docker
$ service docker start
$ 
# clone apollo repo: has to be cloned in root path
$ cd /
$ git clone https://github.com/ApolloAuto/apollo.git
$ 
# then follow https://github.com/ApolloAuto/apollo/blob/master/docs/quickstart/apollo_software_installation_guide.md to install/build apollo
```

## Author
wangyoucao577@gmail.com
