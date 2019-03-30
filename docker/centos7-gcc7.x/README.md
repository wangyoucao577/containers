# centos7-gcc7.x
Docker image based on `CentOS7`, installed `gcc-7.4.0` compiler and running libraries(`libstdc++`, etc.).    

## Build Image
```bash
$ cd docker/centos7-gcc7.x

# parallel make
docker build -t wangyoucao577/centos7-gcc7.4 --build-arg="-j" .

# OR single cpu make (default behavior), suitable for DockerHub Automated Build
docker build -t wangyoucao577/centos7-gcc7.4 .
```

## Installed Tools
- `gcc-7.4.0`
    - `libstdc++.so.6.0.24`   
- `git-2.x`    
- `cmake-3.14.1`

## Author
wangyoucao577@gmail.com


