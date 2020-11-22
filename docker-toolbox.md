# Docker Toolbox

Docker Desktop for Windows provides native support for Windows built-in Hyper-V virtual machine. But for some legacy systems, or in some cases, you can not give up VirtualBox, you could have to use Docker Toolbox.

Docker Toolbox supports Windows and Mac OS system, which ship with a Boot2Docker image, and run docker in VirtualBox. In your system, the `docker` command is connecting to the hosted docker daemon in the virtual machine.

## Docker machine

Docker Toolbox includes a series of tools, one is `docker-machine` which is use for managing virtual machines.

Start up the Toolbox shipped **Quickstart shell** prompt. By default, it will try to start up the default machine if it exists or create one for you.

Execute the following command to create a new virtual machine.

```
docker-machine create -d virtualbox --engine-registry-mirror https://registry.docker-cn.com 
--virtualbox-share-folder "/e:e"
--engine-insecure-registry 192.168.99.100:5000
--virtualbox-memory 2048
meandev 

```

Add a docker registry to the existing docker machine.

```
docker-machine ssh default "echo 'EXTRA_ARGS=\"--registry-mirror=https://registry.docker-cn.com \"' | sudo tee -a /var/lib/boot2docker/profile"
```

When it is done, a new virtual machine will be ready in VirtualBox.

Check the new machine environment.

```
docker-machine env meandev
```

You will see the following info.

```
$ docker-machine env meandev
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.101:2376"
export DOCKER_CERT_PATH="E:\Users\hantsy\.docker\machine\machines\meandev"
export DOCKER_MACHINE_NAME="meandev"
export COMPOSE_CONVERT_WINDOWS_PATHS="true"
# Run this command to configure your shell:
# eval $("C:\Program Files\Docker Toolbox\docker-machine.exe" env meandev)
```

Now connect your shell to the new created machine.

```
eval "$(docker-machine env meandev)"
```

Verify if you have selected the **meandev** machine.

```
$ docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
default   -        virtualbox   Stopped                                       Unknown
meandev   *        virtualbox   Running   tcp://192.168.99.101:2376           v17.03.0-ce
```

You can use the following commands to start and stop a machine.

```
docker-machine start meandev
docker-machine stop meandev
```

You can use the `rm` command to remove a machine.

```
docker-machine rm meandev
```

For all available commands, use `docker-machine help` to get detailed help.

## Troubleshoots

### Port forwarding to localhost

Under Windows, when use Docker Toolbox and VirtualBox, you can not access the server in docker via *localhost*. You have to expose the VirtualBox ports to host machine. 

Make sure the machine is stop. 

```
VBoxManage modifyvm "meandev" --natpf1 "tcp-port3306,tcp,,3306,,3306"
VBoxManage modifyvm "meandev" --natpf1 "udp-port3306,udp,,3306,,3306"
```

*meandev* is the machine name.

Alternatively, you can edit it in VirtualBox directly.

1. Open VirtualBox
2. Select *meandev* machine.
3. Right click it and select *Settings* item in the context menu.
4. Select *Network/Adapter（NAT）/Advanced* in the *Settings* panel. 
5. Click *Ports Forwarding* to edit it in the new popup window.

### Configure docker registry mirror

Docker pull is very slow and periodical breaking in China, luckily there are some companies or organizations provide docker hub mirror service.

* [Docker CN][docker-cn]
* [NetEase][163]
* [DaoCloud][daocloud]
* [AliYun][alicloud]
* [USTC][ustc]
* [Tencent](https://mirror.ccs.tencentyun.com)

Docker for Windows configuration.

```shell
{
  "registry-mirrors": [
    "https://mirror.ccs.tencentyun.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com/"
  ],
  "insecure-registries": [],
  "debug": true,
  "experimental": true,
  "features": {
    "buildkit": true
  }
}
```

Helpful docs to configure docker hub mirrors.

* [国内 docker 镜像比较](http://www.datastart.cn/tech/2016/09/28/docker-mirror.html)
* [Docker 使用帮助](https://lug.ustc.edu.cn/wiki/mirrors/help/docker)
* [DockerHub 镜像加速](https://c.163.com/wiki/index.php?title=DockerHub%E9%95%9C%E5%83%8F%E5%8A%A0%E9%80%9F)
---
[docker-cn]:https://registry.docker-cn.com
[163]:https://c.163.com/
[daocloud]:https://daocloud.io
[alicloud]:https://aliyuncs.com
[ustc]:https://ustc.edu.cn
