# Containers
Container images and orchestration, i.e. [docker](https://docs.docker.com/), [kubernetes](https://kubernetes.io/), etc.        

- [Issues, experiences, knowledges and references when I'm working with Docker.](docker/)


## Docker Images
[DockerHub - wangyoucao577](https://cloud.docker.com/u/wangyoucao577/repository/list)    

### centos7-thrift
Docker image based on `CentOS7`, installed latest `thrift` and `boost` compiled by `gcc-7.4.0`.    
See details in [docker/centos7-thrift](./docker/centos7-thrift/).    

### centos7-gcc7.x
![Build Docker - centos7-gcc7.x](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20centos7-gcc7.x/badge.svg)    
Docker image based on `CentOS7`, installed `gcc-7.4.0` compiler and running libraries(`libstdc++`, etc.).    
See details in [docker/centos7-gcc7.x](./docker/centos7-gcc7.x/).    

### centos7-gcc6.x
Docker image based on `CentOS7`, installed `gcc-6.5.0` compiler and running libraries(`libstdc++`, etc.).    
See details in [docker/centos7-gcc6.x](./docker/centos7-gcc6.x/).    

### osrm-backend-dev
![Build Docker - osrm-backend-dev](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20osrm-backend-dev/badge.svg)    
My personal docker image for [osrm-backend](https://github.com/Telenav/osrm-backend) development. It's based on the [telenavmap/osrm-backend-dev](https://github.com/Telenav/osrm-backend/tree/master-telenav/docker-orchestration/osrm-backend-dev) which includes all dependencies.     
See details in [docker/osrm-backend-dev](./docker/osrm-backend-dev/).    

### osmium-tool
![Build Docker - osmium-tool](https://github.com/wangyoucao577/containers/workflows/Build%20Docker%20-%20osmium-tool/badge.svg)      
Docker image to wrap [osmium-tool](https://github.com/osmcode/osmium-tool) that can be used like a command line tool.     
See details in [docker/osmium-tool](./docker/osmium-tool/).    
