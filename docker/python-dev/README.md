# Python development environment 

## Build image
```bash
docker build -t python-dev:v1 .
```

## Run unit test
```bash
docker run --rm python-dev:v1 make test
```

## Enter container
```bash
docker run --rm -it python-dev:v1 /bin/bash
```

