# Daily Docker Commands

Run a container .

```bash
docker run nginx
```





List containers.

```bash
docker ps
docker ps -a// list all containers, including inactive containers.
```
List images.

```bash
docker images
```

Remove all docker containers, add a `-q` parameter to get the container ids.

```bash 
docker rm $(docker ps -a -q)
```

Stop all docker containers.

```bash 
docker stop $(docker ps -a -q)
```

Similarly, remove all docker images.

```bash
docker rmi $(docker images -q)
```