# osrm-backend-dev
![Build Docker - osrm-backend-dev](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20osrm-backend-dev/badge.svg)     
My personal docker image for [osrm-backend](https://github.com/Telenav/osrm-backend) development. It's based on the [telenavmap/osrm-backend-dev](https://github.com/Telenav/osrm-backend/tree/master-telenav/docker-orchestration/osrm-backend-dev) which includes all dependencies.     
 
## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/osrm-backend-dev
$ docker build -t wangyoucao577/osrm-backend-dev .  
```

## Pull Image 
### DockerHub
[DockerHub Repo: wangyoucao577/osrm-backend-dev](https://hub.docker.com/r/wangyoucao577/osrm-backend-dev)    
```bash
$ docker pull wangyoucao577/osrm-backend-dev
```

### Github Package
[Github Package Repo: docker.pkg.github.com/wangyoucao577/containers/osrm-backend-dev](https://github.com/wangyoucao577/containers/packages/141148)

```bash
$ docker pull docker.pkg.github.com/wangyoucao577/containers/osrm-backend-dev:master-f4f4ccf-20200301
```

## Run container

```bash
$ docker run -d -p 19001:22 --shm-size 64g --cap-add=SYS_PTRACE --security-opt seccomp=unconfined wangyoucao577/osrm-backend-dev
4dce06ca751f4ee803df809396b8e1ed830f496ed530f52476034a92d35c8fe2
```

After run above command, we get a deamon container which can be connect by `ssh` via port `19001`. `--cap-add=SYS_PTRACE --security-opt seccomp=unconfined` is used to let `gdb` works, more discussion see [Docker - Issues Encountered](../docker#issues-encountered), and [How to use GDB within Docker Container](https://github.com/tonyOreglia/argument-counter/wiki/How-to-use-GDB-within-Docker-Container) explains it very well.         


## Remote Debug via VSCode
Refer to [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) for more usage.    

### Prerequirements

- Install latest [VSCode](https://code.visualstudio.com/) on your local 

### Debugging via [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

- Install [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in your local vscode
- TODO:     

### Debugging via [Remote-SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

- Install [Remote-SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension in your local vscode 
- Make sure `ssh` works on your local machine: `ssh -i <YOUR_PRIVATE_KEY> -p 19001 root@<CONTAINER_IP>`
- Use "Remote-SSH: Connect to Host" to connect to your container in vscode
- Install vscode extensions remotely
  - The [C/C++ extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) is mandatory. 
  - All other extensions are optional but good to have, e.g. [Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory), [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens), etc.    
  - Either install from the vscode Extensions page,
  - Or install by "Extensions: Install from VSIX", choose `/workspace/vscode/cpptools-linux.vsix`
- "Open Folder", choose `/workspace/osrm-backend`
- "Tasks: Run Task", run `cmake debug generate`
- "Tasks: Run Task", run `build debug`
- `F5` to launch program, add breakpoints to debug


## Author
wangyoucao577@gmail.com
