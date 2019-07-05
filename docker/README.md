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
