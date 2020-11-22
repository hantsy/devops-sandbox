# Installing Kubernetes(K8S)



## Minikube 

Generally, it is easy to start a Minikube using the following command.

```bas
minikube start
```

You can assign the hardware resources.

```bash
minikube start --cpus 2 --memory 4096 --disk 10g
```

Configure these globally.

```bash
minikube config set cpus 2
mimikube config set memory 4096
```

Minikube supports different VMs, such as VirtualBox or  Microsoft Hyper V, specify a virtual machine like this.

```bash
minikube start --driver=hyperv 
```

> If you are using Docker for Windows, you have to use Hyper-V which can not co-exists with other Virtual Machines.

Specify another different Kubernets version.

```bash
minikube start --kubernetes-version=v1.19.0
```

Use a different Minikube ISO URL to download the ISO image.

```bash
minikube start --iso-url=<minikube.iso url>
```

### Installation issue in China

For Chinese users,  due to some unbreakable reason preparing a Kubernetes cluster in the local development environment is really not easy work.

There are some approaches you  can have a try.

Configuring a global proxy is always recommended.

```bash
$ export HTTP_PROXY = <proxy host>:<port>
$ export HTTPS_PROXY = <proxy host>:<port>

//windows users
$ set HTTP_PROXY = <proxy host>:<port>
$ set HTTPS_PROXY = <proxy host>:<port>
```

In the start up stage, Minikube will perform some preparing work on Docker, there maybe other issues you will encounter.

Try to pass through the proxy settings to the internal docker environment.

```bash
minikube start --docker-env HTTP_PROXY=<proxy host>:<port> --docker-env HTTPS_PROXY=<proxy host>:<port>
```

For the Docker in the Hyper V virtual machine, you can also specify a docker registry mirror.

```bash
minikube start --registry-mirror="https://hub-mirror.c.163.com"
```

And use `--image-mirror-country="cn"` to switch to use the China mirrors to fetch K8s related images. By default it will use the registry service provided by AliCloud. 

Or specify `--image-repository="registry.cn-hangzhou.aliyuncs.com/google_containers"` directly to use an accessible image cache mirror to overcome the barrier. 

> Microsoft's [gcr.azk8s.cn](gcr.azk8s.cn) also provides a lot of mirror service for Chinese users. It is mainly oriented for Azure Chinese customers.

Although we used local mirrors for K8s and Docker, in the Minikube preparing stage, *it will hit the googleapis.com*, which is also not accessible periodically in China (some time it is accessible). Thus using an secured external proxy server could be the final effective solution till now.



## KinD

Follow the [Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/) to install KinD.

Use the following command to create a new cluster.

```bash
kind create cluster --name test
```
When using Docker Desktop, you can integrate Docker environment in your WSL system, eg. Ubuntu 20.04. Go to *Resources/WSL Integration* in the Docker **Settings** panel, select the options on those Distros you want to integrate.

![docker in wsl](./docker-wsl.png)

Thus the docker environment is available in the WSL system.

Open Windows Terminal,  start a new tab for the WSL system, check docker.

```bash
$ docker -v
Docker version 19.03.13-beta2, build ff3fbc9d55
```

Create a new K8S cluster using `kind` command.

```bash
$ kind create cluster --image kindest/node:v1.19.0 --name wslkind -v 1
Creating cluster "wslkind" ...
DEBUG: docker/images.go:58] Image: kindest/node:v1.19.0 present locally
 ✓ Ensuring node image (kindest/node:v1.19.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-wslkind"
You can now use your cluster with:

kubectl cluster-info --context kind-wslkind

Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
```

Get the cluster info.

```bash
$ kubectl --cluster-info --context kind-wslkind
Error: unknown command "kind-wslkind" for "kubectl"
Run 'kubectl --help' for usage.
hantsy@hantsy-t540p:/etc$ kubectl cluster-info --context kind-wslkind
Kubernetes master is running at https://127.0.0.1:34367
KubeDNS is running at https://127.0.0.1:34367/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

Different from Minikube which creates a K8S environment in the virtual machine, the above `kind`command bootstraps a K8S cluster in a Docker container.

```bash
$ docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                       NAMES
a644f8b61314        kindest/node:v1.19.0   "/usr/local/bin/entr…"   3 minutes ago       Up 3 minutes        127.0.0.1:52301->6443/tcp   wslkind-control-plaserne
```

Kind uses [containerd](https://github.com/containerd) instead of Docker as container engine. 

```bash
$ kubectl run nginx --image=nginx
```

This command also will fail because docker is not available in kind,  see [the details on Stackoverflow](https://stackoverflow.com/questions/63657414/kind-kubernetes-cluster-failed-to-pull-docker-images).

A possible solution is using your local docker to pull image firstly, then load them into K8s by `kind load` command.

```bash
$ docker pull nginx
$ kind load docker-image nginx --name kind-dev
$ kubectl run nginx
```



## Reference

* [Use gcr.io and minikube in China](https://github.com/wellls/wellls/issues/51)

* [Document how to run minikube in China](https://github.com/kubernetes/minikube/issues/5020)

* [gcr.azk8s.cn/google_containers](gcr.azk8s.cn/google_containers)

* [WSL+Docker: Kubernetes on the Windows Desktop](https://kubernetes.io/blog/2020/05/21/wsl-docker-kubernetes-on-the-windows-desktop/)

* [KinD Docs](https://kind.sigs.k8s.io/)

* [MiniKube Docs](https://minikube.sigs.k8s.io/docs/start/)

* [Kubernetes Cheetsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

  

