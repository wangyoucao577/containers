# debian10-dev
![Build Docker - debian10-dev](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20debian10-dev/badge.svg)    
All-in-one dev image based on `debian:buster` for my daily development.     

## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/debian10-dev
$ docker build -t wangyoucao577/debian10-dev .  
```

## Pull Image 
### DockerHub
[DockerHub Repo: wangyoucao577/debian10-dev](https://hub.docker.com/r/wangyoucao577/debian10-dev)    
```bash
$ docker pull wangyoucao577/debian10-dev
```

### Github Container Registry
[Github Container Repo: wangyoucao577/debian10-dev](https://github.com/users/wangyoucao577/packages/container/package/debian10-dev)
```bash
$ docker pull ghcr.io/wangyoucao577/debian10-dev
```

### Github Package
[Github Package Repo: docker.pkg.github.com/wangyoucao577/containers/debian10-dev](https://github.com/wangyoucao577/containers/packages/493706)

```bash
$ docker pull docker.pkg.github.com/wangyoucao577/containers/debian10-dev
```


## Run container

```bash
$ docker run -d --restart=always -p 13191:22 --cap-add=ALL --security-opt seccomp=unconfined wangyoucao577/debian10-dev
4dce06ca751f4ee803df809396b8e1ed830f496ed530f52476034a92d35c8fe2
```
### Docker-in-docker
[jpetazzo/dind](https://github.com/jpetazzo/dind) and [Using Docker-in-Docker for your CI or testing environment? Think twice.](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) provides awesome help on this topic.    

#### Option 1: isolated docker context

- with one more parameter `--privileged` when execute `docker run`
- Run `service docker start` to launch docker deamon after entered container 
- Enjoy! 

#### Option 2: share host docker context
With this option if you run `docker run` inside `docker`, the new container will be launched on host!    

- with one more parameter `-v /var/run/docker.sock:/var/run/docker.sock` when execute `docker run`
- Enjoy!    

NOTE: be aware that this option will no longer available once [Kubernetes is deprecating Docker as a container runtime after v1.20.](https://kubernetes.io/blog/2020/12/02/dont-panic-kubernetes-and-docker/). Check out other options including things like [kaniko](https://github.com/GoogleContainerTools/kaniko), [img](https://github.com/genuinetools/img), and [buildah](https://github.com/containers/buildah).     



## Remote Debug via VSCode
Refer to [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) for more usage.    

### Prerequirements

- Install latest [VSCode](https://code.visualstudio.com/) on your local 

### Debugging via [Remote-SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

- Install [Remote-SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension in your local vscode 
- Make sure `ssh` works on your local machine: `ssh -i <YOUR_PRIVATE_KEY> -p 19001 root@<CONTAINER_IP>`
- Use "Remote-SSH: Connect to Host" to connect to your container in vscode
- Install vscode extensions remotely
  - Either install from the vscode Extensions page, 
  - Or install by "Extensions: Install from VSIX", choose `/root/workspace/vscode/cpptools-linux.vsix`
  - Common extensions:    
    - [C/C++ extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)   
    - [Golang extension](https://marketplace.visualstudio.com/items?itemName=golang.go)
    - [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
    - etc.    
  - "Open Folder", choose your project folder.    
  - Enjoy!    

## Author
wangyoucao577@gmail.com
