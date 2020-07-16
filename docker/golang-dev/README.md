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

![image](https://user-images.githubusercontent.com/16873751/86850540-4aa8e000-c066-11ea-9af4-98bc7513c6e3.png)


## Build image
```
docker build -t golang-dev:v1 .
```

## More info
- Golang Project layout: https://github.com/golang-standards/project-layout
- https://github.com/microsoft/vscode-dev-containers/tree/master/containers/go
