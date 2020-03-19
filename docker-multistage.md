# Docker multi-stage builds

Docker 17.06 introduced a new feature, Multi-stage builds, check the Docker blog entry [multi stage builds](https://blog.docker.com/2017/07/multi-stage-builds/?mkt_tok=eyJpIjoiTVdabE9XUXpNbUl6T1RkbCIsInQiOiI3NmZMREpaZ1U5aTJpSDErU0o0WTRvclg5Y3IwVE9BOEdEanV3NFJNKzhXdHBTZUx0MjNOakQ4d3FDNTJ5SitDRGVIcUNEVFg1SFlTMkphSzZkdTFvRFwvcDNRUDFFRkVqM1N4eWQ0UVMzMVcyc25kRyt0V0dmZ2RZUEtcL1Buek4wIn0%3D) or new [multistage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) section in the docker official documentation for more details.

I tried to add a multi-stage Dockefile to build my sample project  [angularjs-springmvc-sample-boot](https://github.com/hantsy/angularjs-springmvc-sample-boot) into Docker images and run it in Docker container.

```
FROM node:latest AS ui
WORKDIR /usr/src/ui
COPY package.json .
# Setup NPM mirror, optionally for China users.
# RUN npm config set registry https://registry.npm.taobao.org/ 
RUN npm install 
COPY . .
RUN node_modules/.bin/bower install --allow-root
RUN node_modules/.bin/gulp

FROM maven:latest AS boot
WORKDIR /usr/src/app
COPY pom.xml .
# COPY settings.xml /usr/share/maven/ref/settings-docker.xml
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml clean package -DskipTests
 
FROM java:8-jdk-alpine
WORKDIR /static
COPY --from=ui /usr/src/ui/dist/ .
WORKDIR /app
COPY --from=boot /usr/src/app/target/angularjs-springmvc-sample-boot.jar .
ENTRYPOINT ["java", "-jar", "/app/angularjs-springmvc-sample-boot.jar"]

```

There are multi **FROM** in this Dockerfile, the **AS** is use for naming a stage.

In the final stage, **COPY** command accepts a **--from** parameter to refer a former stage.

In our Dockerfile:

* **ui** build the frontend codes into dist folder.
* **boot** build the Spring Boot based backend codes into a jar.
* The final stage will run this project.

Follow the [Docker Toolbox notes](https://github.com/hantsy/devops-sandbox/blob/master/docker-toolbox.md) and create a new docker machine for test purpose.

Build docker image.

```
docker build -t angularjs-springmvc-multistage .
```

Run `angularjs-springmvc-multistage` in docker container.

```
docker run -it --rm -p 9000:9000  angularjs-springmvc-multistage
```

Open your browser, and navigate http://<docker-machine ip>:9000. 

![multistage docker](https://github.com/hantsy/devops-sandbox/blob/master/multistage.png)
