# nginx-file-server
![Build Docker - nginx-file-server](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20nginx-file-server/badge.svg)       
`nginx` based docker image to serve static files as default.     


## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/nginx-file-server
$ docker build -t wangyoucao577/nginx-file-server .  
```

## Pull Image 
### DockerHub
[DockerHub Repo: wangyoucao577/nginx-file-server](https://hub.docker.com/r/wangyoucao577/nginx-file-server)    
```bash
$ docker pull wangyoucao577/nginx-file-server
```

### Github Container Registry
[Github Container Repo: wangyoucao577/nginx-file-server](https://github.com/users/wangyoucao577/packages/container/package/nginx-file-server)
```bash
$ docker pull ghcr.io/wangyoucao577/nginx-file-server
```

## Run container

```bash
$ docker run -d --restart=always -p 80:80 --mount "src=YOUR_FILES,dst=/files,type=bind" wangyoucao577/nginx-file-server
4dce06ca751f4ee803df809396b8e1ed830f496ed530f52476034a92d35c8fe2
$ 
$ # access your files in browser, enjoy!
$ curl "http://localhost/"
```

## Author
wangyoucao577@gmail.com
