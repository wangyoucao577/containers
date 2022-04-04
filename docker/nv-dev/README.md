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
