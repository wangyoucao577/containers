# centos7-gcc6.x
Docker image based on `CentOS7`, installed `gcc-6.5.0` compiler and running libraries(`libstdc++`, etc.).    

## Build Image
```bash
$ cd docker/centos7-gcc6.x

# parallel make
docker build -t wangyoucao577/centos7-gcc6.5 --build-arg MAKE_EXTRA_ARGS="-j" .

# OR single cpu make (default behavior), suitable for DockerHub Automated Build
docker build -t wangyoucao577/centos7-gcc6.5 .
```

## Installed Tools
- `gcc-6.5.0`
    - `libstdc++.so.6.0.22`   
- `git-2.x`    
- `cmake-3.14.1`

## Pull Image from DockerHub
[DockerHub Repo: wangyoucao577/centos7-gcc6.5](https://hub.docker.com/r/wangyoucao577/centos7-gcc6.5)    
```bash
docker pull wangyoucao577/centos7-gcc6.5
```

## Author
wangyoucao577@gmail.com


