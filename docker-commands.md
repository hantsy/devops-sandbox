# Daily Docker Commands

## Docker Container

Run a container from image.

```bash
docker run nginx
```

Tag, default is *latest*.

``` bash
docker run redis:4.0
```

Interactive mode.

```bash
docker run -i redis
```

Attach a terminal.

```bash
docker run -t redis
```

Port mapping.

```bash
docker run -p 80:80 redis
docker run -p 81:80 redis
```

Volume mapping.

```bash
docker run -v /data:/var/lib/mysql mysql
```

Inspect container.

```bash
docker inpsect <docker id or name>
```

Container logs.

```bash
docker logs <doker id or name>
```

Environment variable.

```bash
docker run -e key=value mysql
```

Append a command.

```bash
docker run ubuntu sleep 5
```

Execute a command .

```bash
docker exec <docker id or name> cat /etc/hosts
```

Detach mode.

```bash
docker run -d nginx
```

Attach to a container.

```bash
docker attach <docker id or name, eg.a043d> 
```

List containers.

```bash
docker ps
docker ps -a// list all containers, including inactive containers.
```

Remove all docker containers, add a `-q` parameter to get the container ids.

```bash 
docker rm $(docker ps -a -q)
docker rm $(docker ps -a -q) -f //by force, will remove the active containers.
```

Stop all docker containers.

```bash 
docker stop $(docker ps -a -q)
```

## Backup and Restore

Export the container content into an tar arhive.

```bash
docker export <docker id or name> -o ng.tar
docker save  <image name> -o myng.tar
```

Restore the archive.

```bash
docker import <file name> <repository:tag>
docker load -i <file name or stdin>
// use `docker images` to shwo all images.
```

## Docker Images

Pull a docker image.

```bash
docker pull nginx

//`docker run` will pull the image firstly.
```

List All Docker images.

```bash
docker images
docker image ls
```
Similarly, remove all docker images.

```bash
docker rmi $(docker images -q)
```

Create an image.

```bas
FROM ubuntu 
RUN apt-get update
RUN apt-get install python
RUN pip install flask
RUN pip install flask-mysql
COPY . /app
ENTRYPOINT ./entrypoint.sh
```

```bash
docker build -f Dockerfile -t hantsy/myapp .
```

## Networking

bridge

```bash
docker run ubuntu 
```

none

```bash
docker run ubuntu --network=none
```

host

```bash
docker run ubuntu --network=host
```

Custom network.

```bash
docker network create --driver bridge --subnet 182.18.0.0/16 custom-isolated-network
```

List networks

```bash
docker network ls
```

Inspect.

```bash
docker inspect <network name>
```

## Storage

File system.

```bas
docker volume create data_volume
docker run -v data_volume:/var/lib/mysql mysql
docker run -v /data/mysql:/var/lib/mysql mysql
```



```bash
docker run --mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql
```

Storage  drivers.

* AUFS
* ZFS
* BTRFS
* Device Mapper
* Overlay
* Overlay2

## Docker Compose

Docker compose  yaml sample.

```yaml
version:3
services:
  reids:
    image:redis
    networks:
      - back-end
  db:
    image:posgres
    networks:
      - back-end
  vote:
    image:voting-app
    ports:
       - 5000:80
    links:
       - redis
    networks:
      - front-end
      - back-end  
  result:
    image:result-app
    ports:
       - 5001:80
    links:
       - db
    networks:
      - front-end
      - back-end   
  worker:
    image:worker
    links:
       - db
       - redis
    networks:
      - front-end
      - back-end    
networks:
  front-end:
  back-end:
```

```bash 
docker run -d --name=redis redis
docker run -d --name=db postgres
docker run -d --name=vote -p 5000:80 --link redis:redis voting-app
docker run -d --name=result -p 5001:80 --link db:db result-app
docker run -d --name=worker --link db:db --link redis:redis worker 
```

## Registry

```bash
docker pull nginx
docker login
docker tag user-service localhost:5000/user-service
docker push hantsy/user-service
```

## Container Orchestration

```bash
docker service create --replicas=2 nodejs
```



## Docker Swarm

```bash
docker swarm init
```

