# centos7-gcc7.x
![Build Docker - centos7-gcc7.x](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20centos7-gcc7.x/badge.svg)     
Docker image based on `CentOS7`, installed `gcc-7.4.0` compiler and running libraries(`libstdc++`, etc.).    

## Build Image
- [Dockerfile](./Dockerfile)

```bash
$ cd docker/centos7-gcc7.x

# parallel make
docker build -t wangyoucao577/centos7-gcc7.4 --build-arg MAKE_EXTRA_ARGS="-j" .

# OR single cpu make (default behavior), suitable for DockerHub Automated Build
docker build -t wangyoucao577/centos7-gcc7.4 .
```

## Installed Tools
- `gcc-7.4.0`
    - `libstdc++.so.6.0.24`   
- `libtool-2.4.6`
- `git-2.x`    
- `cmake-3.14.1`
- `python2.7.16`(default)
- `python3.7.3`(run by `python3`)
- `go-1.12.5`

## Pull Image from DockerHub
[DockerHub Repo: wangyoucao577/centos7-gcc7.4](https://hub.docker.com/r/wangyoucao577/centos7-gcc7.4)    
```bash
docker pull wangyoucao577/centos7-gcc7.4
```

## Author
wangyoucao577@gmail.com

