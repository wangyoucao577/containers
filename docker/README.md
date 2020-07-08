- [Docker Resources](#docker-resources)
  - [Issues Encountered](#issues-encountered)
    - [1. Max length of docker image tag](#1-max-length-of-docker-image-tag)
    - [2. What if container out of memory](#2-what-if-container-out-of-memory)
    - [3. Sharing previously image layer when docker build](#3-sharing-previously-image-layer-when-docker-build)
    - [4. DOCKER_BUILDKIT=1 can not support special character in URL](#4-docker_buildkit1-can-not-support-special-character-in-url)
    - [5. Docker container(run apache httpd inside) can not be started again after stop it by `docker stop`](#5-docker-containerrun-apache-httpd-inside-can-not-be-started-again-after-stop-it-by-docker-stop)
    - [6. `gdb` can not work in container](#6-gdb-can-not-work-in-container)
    - [7. Failed to export image](#7-failed-to-export-image)
    - [8. Using SSH to access private data in builds](#8-using-ssh-to-access-private-data-in-builds)
  - [References](#references)

# Docker Resources
Issues, experiences, knowledges and references when I'm working with Docker.    

## Issues Encountered
### 1. Max length of docker image tag
I hope I can provide sufficent and complete information by the docker image tag. But in my test(based on `docker 18.09.3`), the max length of image tag is only `128 chars`, otherwise the `docker build/tag` command will fail.    
Also find that this limitation has been described in [Docker CLI - docker tag](https://docs.docker.com/engine/reference/commandline/tag/):     
**A tag name must be valid ASCII and may contain lowercase and uppercase letters, digits, underscores, periods and dashes. A tag name may not start with a period or a dash and may contain a maximum of 128 characters.**).     


### 2. What if container out of memory
In my test(`based on centos7, docker 18.09.3`), if docker container try to alloc memory more than the host can provide, not only the process inside container will crash, but also the host might be hung up or crash.     
So be careful about how much memory the container will be needed. It's better to set memory limitation on container when `docker run`.          

### 3. Sharing previously image layer when docker build
- Let's say we want to build two docker images `IMAGE_A` and `IMAGE_B`.    
    - Both of them will have `5` layers.    
    - Contents of the first `4` layers of them are the same, only contents in top layer of them will be different.    
- If we follow below steps to build `IMAGE_A` and `IMAGE_B`:     
    - run `docker build -t IMAGE_A` to build `IMAGE_A` and succeed.    
    - `docker push IMAGE_A`
    - `docker rmi IMAGE_A`
    - run `docker build -t IMAGE_B` to build `IMAGE_B` and succeed.    
    - `docker push IMAGE_B`
    - `docker rmi IMAGE_B`    
- Once both `IMAGE_A` and `IAMGE_B` have been built, 
    - If you use `docker history` to see layers of them, you'll find that `IMAGE_B` didn't share any layer from `IMAGE_A` except the base image(`FROM xxx`). 
    - The root cause is all layers of `IMAGE_A` has been removed on this build machine. `docker build` don't know that same layers have been built before for `IMAGE_A` when building `IMAGE_B`. So all layers will be built again with different layer id.    
    - Be noted that if `docker rmi IMAGE_A` then `docker pull IMAGE_A` again, the sharing still won't work because the `docker pull` will not pull all history of image.(you can see a lot of `<missing>` when you run `docker history IMAGE_A`).         

If it's important to share middle layers(e.g. some middle layers are very large and valuable to share to save time for `push/pull`),     
**DON'T delete any previously built image on your build machine.**      

### 4. DOCKER_BUILDKIT=1 can not support special character in URL
People have reported same issue to docker team already: [Buildkit builds misinterpret encoded URLs ("%3D" changed to "%!D(MISSING)")](https://github.com/docker/for-linux/issues/714).     
We have to wait docker team to fix this issue. Before that the workaround can be NOT enable `DOCKER_BUILDKIT=1`.    

### 5. Docker container(run apache httpd inside) can not be started again after stop it by `docker stop`
I met this issue when I run `apache` docker by `apachectl -k restart -D FOREGROUND` in a `start_httpd_foreground.sh` script.     

- The first issue here is that I use a script as entrypoint in docker, so its `PID` inside docker will be `1`. (We can use `docker exec {container id} ps -ef` to see all processes inside container.)     
  - The `docker stop` command will try to gracefully stop the container by send a signal(default `TERM`) to the `PID 1` process. If it's not stopped in several seconds(default `10`), docker will force to stop it. 
  - Since the script will not forward signals to any child processes, i.e. the `httpd` process, it will not stop gracefully. The docker force stop seems make something wrong on it so that the container can not restart again.    
  - To solve this issue, I refer to [apache httpd docker library](https://github.com/docker-library/httpd), use `exec httpd -k restart -D FOREGROUND` instead of `apachectl -k restart -D FOREGROUND`. The `exec` command here gives the `httpd` as `PID 1`. After that, the container can be stopped and restart again.    
- The [apache httpd docker library](https://github.com/docker-library/httpd) also shows 2 more best practices for `apache httpd` docker:     
  - `rm -f /usr/local/apache2/logs/httpd.pid` in [httpd_foreground](https://github.com/docker-library/httpd/blob/master/2.4/httpd-foreground) script, which can fix `Apache` gets grumpy about PID files pre-existing.     
  - `STOPSIGNAL WINCH` in [Dockerfile](https://github.com/docker-library/httpd/blob/master/2.4/Dockerfile), which try to gracefully stop `apache httpd`. See [apache http stopping](https://httpd.apache.org/docs/current/stopping.html#gracefulstop) in details.    
- Some references for this issue:     
  - [apache httpd docker library](https://github.com/docker-library/httpd)
  - [apache http stopping](https://httpd.apache.org/docs/current/stopping.html#gracefulstop)
  - [Gracefully Stopping Docker Containers](https://www.ctl.io/developers/blog/post/gracefully-stopping-docker-containers/)
  - [What does Docker STOPSIGNAL do?](https://stackoverflow.com/questions/50898134/what-does-docker-stopsignal-do)

### 6. `gdb` can not work in container
When I try to run my [docker/osrm-backend-dev] container to debug, I found that `gdb` can not break on breakpoints, the program continues directly instead.     
In which case `gdb` reports `warning: Error disabling address space randomization: Operation not permitted`, it seems `gdb` has been limited in container.     
After `docker run` with extra parameters `--cap-add=SYS_PTRACE --security-opt seccomp=unconfined` which suggested by [Stackoverflow - warning: Error disabling address space randomization: Operation not permitted](https://stackoverflow.com/questions/35860527/warning-error-disabling-address-space-randomization-operation-not-permitted), `gdb` works well.      
Why the `--cap-add=SYS_PTRACE --security-opt seccomp=unconfined` works? The wiki [How to use GDB within Docker Container](https://github.com/tonyOreglia/argument-counter/wiki/How-to-use-GDB-within-Docker-Container) explains it very well.                

### 7. Failed to export image
We met a lot of `failed to export image` errors when execute `COPY` in `Dockerfile`(`docker build`). The error message that we met are:        
- `failed to export image: failed to set parent ...` 
- `failed to export image: failed to create image: failed to get layer ...`

It seems a bug of `docker` that has not been fixed yet, see more details in https://github.com/moby/moby/issues/33974, https://github.com/moby/moby/issues/37965, https://github.com/moby/moby/issues/36573, https://github.com/moby/moby/issues/36901.        
As [this comment](https://github.com/moby/moby/issues/37965#issue-366585696) mentioned, [Build images with BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/)(i.e., `DOCKER_BUILDKIT=1`) could be a workaround. However, I met another issue that `docker build` shows succeed but `docker push` fails due to can not find image after enable the `BuildKit`.     
[comment](https://github.com/moby/moby/issues/37965#issuecomment-426853382) shows another workaround that insert `RUN true` between `COPY`s, but it requires modification on `Dockerfile` which is not a good idea most of time.     
Final workaround to me:     
- Enable `BuildKit`
- retry `docker build + docker push` if any error occurs       

### 8. Using SSH to access private data in builds 

Sometimes we may want to access private data when `docker build` (i.e., in `Dockerfile`). For example, clone code from private `git` repo. The clone process requires credential(username/password or `ssh` private key) for authecation.     
There're ways can do it:    
  - pass password by `docker build --build-arg`, and `git clone -n https://${GIT_REPO_USERNAME}:${GIT_REPO_PASSWORD}@{repo-url}.git` in `Dockerfile`      
  - use `ADD/COPY` to copy ssh private key into `Dockerfile`, and clone via `ssh` in `Dockerfile`    
However, both of them have security issue and not recommended. Because the actual command is executed in plain inside docker. We'll see them if inspect the layers after building. Even most of time we'll use [Jenkins - Using credentials](https://www.jenkins.io/doc/book/using/using-credentials/) to store and transfer the data to `docker cli`, the `docker cli` still just gets that as arguments in plain, so from its perspective is not sensitive data.     

**Solution**:     
[Docker Buildkit, start from version 18.09](https://docs.docker.com/engine/reference/builder/#buildkit) provides new `--secret` and `--ssh` command line options that allow the user to pass secret information for building new images with a specified `Dockerfile`. Read more in [Build images with BuildKit - Using SSH to access private data in builds](https://docs.docker.com/develop/develop-images/build_enhancements/#using-ssh-to-access-private-data-in-builds) and [Build secrets and SSH forwarding in Docker 18.09](https://medium.com/@tonistiigi/build-secrets-and-ssh-forwarding-in-docker-18-09-ae8161d066). The `--ssh` is based on `ssh` agent forwarding technology(read more in [An Illustrated Guide to SSH Agent Forwarding](http://www.unixwiz.net/techtips/ssh-agent-forwarding.html)), which is perfect for this scenario.     
Two phases to leaverage the `--ssh`:     
- make sure host has already launched `ssh-agent` with valid private key
  - This part requires to understand the base knowledges of the `ssh` technology. Then [ssh-agent - Single Sign-On using SSH](https://www.ssh.com/ssh/agent) introduced the basic usage.       
  - If use Jenkins for automation, [Jenkins SSH Agent Plugin](https://www.jenkins.io/doc/pipeline/steps/ssh-agent/) can help.     
- update `Dockerfile` refer to [Build images with BuildKit - Using SSH to access private data in builds](https://docs.docker.com/develop/develop-images/build_enhancements/#using-ssh-to-access-private-data-in-builds)



## References
- [Get Docker CE for CentOS](https://docs.docker.com/install/linux/docker-ce/centos/)
- [Docker Command Line Docs](https://docs.docker.com/engine/reference/run/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker development best practices](https://docs.docker.com/develop/dev-best-practices/)
- [About storage drivers](https://docs.docker.com/storage/storagedriver/)
- [Use Volumes](https://docs.docker.com/storage/volumes/)
- [Storage Overview - Manage Data in Docker](https://docs.docker.com/storage/)
- [Use multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)
- [Docker Buildkit, start from version 18.09](https://docs.docker.com/engine/reference/builder/#buildkit)
- [Build Enhancements for Docker](https://docs.docker.com/develop/develop-images/build_enhancements/)
- [Docker CLI - docker tag](https://docs.docker.com/engine/reference/commandline/tag/)
- [apache httpd docker library](https://github.com/docker-library/httpd)
- [apache http stopping](https://httpd.apache.org/docs/current/stopping.html#gracefulstop)
- [Gracefully Stopping Docker Containers](https://www.ctl.io/developers/blog/post/gracefully-stopping-docker-containers/)
- [What does Docker STOPSIGNAL do?](https://stackoverflow.com/questions/50898134/what-does-docker-stopsignal-do)
- [How to use GDB within Docker Container](https://github.com/tonyOreglia/argument-counter/wiki/How-to-use-GDB-within-Docker-Container)
- [Seccomp security profiles for Docker](https://docs.docker.com/engine/security/seccomp/)
- [Security Lab: Seccomp](https://training.play-with-docker.com/security-seccomp/)
- [Docker run reference - Security configuration](https://docs.docker.com/engine/reference/run/#security-configuration)
- [Stackoverflow - warning: Error disabling address space randomization: Operation not permitted](https://stackoverflow.com/questions/35860527/warning-error-disabling-address-space-randomization-operation-not-permitted)
- [Build images with BuildKit - Using SSH to access private data in builds](https://docs.docker.com/develop/develop-images/build_enhancements/#using-ssh-to-access-private-data-in-builds)
- [An Illustrated Guide to SSH Agent Forwarding](http://www.unixwiz.net/techtips/ssh-agent-forwarding.html)
- [Build secrets and SSH forwarding in Docker 18.09](https://medium.com/@tonistiigi/build-secrets-and-ssh-forwarding-in-docker-18-09-ae8161d066)
- [Jenkins SSH Agent Plugin](https://www.jenkins.io/doc/pipeline/steps/ssh-agent/)
- [Jenkins - Using credentials](https://www.jenkins.io/doc/book/using/using-credentials/)
- [ssh-agent - Single Sign-On using SSH](https://www.ssh.com/ssh/agent)