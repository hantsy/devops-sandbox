# Docker multi-stage builds

Docker 17.06 introduced a new feature, Multi-stage builds, check the Docker blog entry [multi stage builds](https://blog.docker.com/2017/07/multi-stage-builds/?mkt_tok=eyJpIjoiTVdabE9XUXpNbUl6T1RkbCIsInQiOiI3NmZMREpaZ1U5aTJpSDErU0o0WTRvclg5Y3IwVE9BOEdEanV3NFJNKzhXdHBTZUx0MjNOakQ4d3FDNTJ5SitDRGVIcUNEVFg1SFlTMkphSzZkdTFvRFwvcDNRUDFFRkVqM1N4eWQ0UVMzMVcyc25kRyt0V0dmZ2RZUEtcL1Buek4wIn0%3D) or new [multistage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) section in the docker official documentation for more details.

I tried to add a multi-stage Dockefile to build my sample project  [angularjs-springmvc-sample-boot](https://github.com/hantsy/angularjs-springmvc-sample-boot) into Docker images and run it in Docker container.

```
FROM node:latest AS ui
WORKDIR /usr/src/ui
COPY app .
COPY package.json .
COPY gulpfile.js .
COPY bower.json .
COPY .bowerrc .
RUN npm install
RUN npm run build


FROM maven:latest AS boot
WORKDIR /usr/src/app
COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests
 
 
FROM java:8-jdk-alpine
WORKDIR /static
COPY --from=ui /usr/src/ui/dist/ .
WORKDIR /app
COPY --from=boot /usr/src/app/target/angularjs-springmvc-sample-boot-1.0-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "/app/angularjs-springmvc-sample-boot-1.0-SNAPSHOT.jar"]
```

There are multi **FROM** in the same Dockerfile, the **AS** is use for naming a stage.

In the followed stages, **COPY** command can accept a **--from** parameter to refer a former stage.

In our Dockerfile:

* **ui** build the frontend codes into dist folder.
* **boot** build the Spring Boot based backend codes into a jar.
* The final stage will run this project.


