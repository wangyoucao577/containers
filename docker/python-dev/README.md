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

## Remote development with VSCode
```bash
# you might need to add vscode to PATH, or you could run following command on mac
# sudo ln -fs "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/

# in the folder of containers/docker/python-dev
code .
```

Please select "Reopen in Container"

![image](https://user-images.githubusercontent.com/16873751/86662919-0bb15680-bfa2-11ea-830a-00434ef9152d.png)

Happy development inside Container

![image](https://user-images.githubusercontent.com/16873751/86663060-313e6000-bfa2-11ea-8f77-6564a10ab1ff.png)
