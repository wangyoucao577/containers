# osrm-backend-dev
My personal docker image for [osrm-backend](https://github.com/Telenav/osrm-backend) development. It's based on the [telenavmap/osrm-backend-dev](https://github.com/Telenav/osrm-backend/tree/master-telenav/docker-orchestration/osrm-backend-dev) which includes all dependencies.     
 
## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/osrm-backend-dev
$ docker build -t wangyoucao577/osrm-backend-dev .  
```

## Pull Image from DockerHub
[DockerHub Repo: wangyoucao577/osrm-backend-dev](https://hub.docker.com/r/wangyoucao577/osrm-backend-dev)    
```bash
$ docker pull wangyoucao577/osrm-backend-dev
```

## Run container

```bash
$ docker run -d -p 19001:22 --cap-add=SYS_PTRACE --security-opt seccomp=unconfined wangyoucao577/osrm-backend-dev
4dce06ca751f4ee803df809396b8e1ed830f496ed530f52476034a92d35c8fe2
```

After run above command, we get a deamon container which can be connect by `ssh` via port `19001`. `--cap-add=SYS_PTRACE --security-opt seccomp=unconfined` is used to let `gdb` works, more discussion see [Docker - Issues Encountered](../docker#issues-encountered), and [How to use GDB within Docker Container](https://github.com/tonyOreglia/argument-counter/wiki/How-to-use-GDB-within-Docker-Container) explains it very well.         


## Remote Debug via VSCode
Refer to [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview) for more usage.    

### Prerequirements

- Install latest [VSCode](https://code.visualstudio.com/) on your local 

### Debug via [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)


### Debug via [Remote-SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

- Install [Remote-SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension in your vscode 
- Make sure `ssh` works on your local machine: `ssh -i <YOUR_PRIVATE_KEY> -p 19001 root@<CONTAINER_IP>`
- "Remote-SSH: Connect to Host" to connect your container in vscode
- "Extensions: Install from VSIX", choose `/workspace/cpptools-linux.vsix` to install
- "Open Folder", choose `/workspace/osrm-backend`
- "Tasks: Run Task", run `cmake debug generate`
- "Tasks: Run Task", run `build debug`
- `F5` to launch program, add breakpoints to debug


## Author
wangyoucao577@gmail.com


