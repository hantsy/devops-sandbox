# Building a custom Oracle Database XE Docker Image

In these days, I want to connect an Oracle Database to play my sample codes, but I found preparing a Oracle Database instance in my local development environment is not easy.

Installing and configuring a complete full-featured Oracle Database Standard Edition(SE) or Enterprise Edition(EE) will waste too much disk spaces and your time. In before experience, I would like to run a Oracle Database Express Edition(XE) in my local machine to test my application.

Oracle has published Docker Images of the  SE and EE  through Docker hub and self-host [Container registry](https://container-registry.oracle.com/), but there is no a public XE version there.

Oracle maintains a [oracle/docker-images](https://github.com/oracle/docker-images/) repo on Github which contains Dockerfiles for almost all Oracle products, including the XE  version of Oracle Database.

Navigate to [OracleDatabase/SingleInstance/dockerfiles/18.4.0](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance/dockerfiles/18.4.0), fetch all files into your local disc, Make sure you have installed the newest Docker in your system.  For Windows/MacOS users, install the latest Docker for Windows/MacOS.

Enter the folder which contains the Dockerfile resource you have downloaded, then run the following command to build the Docker image.

```bash
docker build -t oracle/database:18.4.0-xe -f Dockerfile.xe .
```

Ideally it will take some minutes to complete.

Unluckily it fails again and again here  when fetching the oracle-database rpm file.  To overcome this barrier, I decide to download the rpm file manually using an external download tool, then perform a small modification on the original *Dockerfile.xe* to make it install the local rpm instead of the remote one.

Firstly , at line 41, replace the rpm URL with a local rpm file.

```bash
    INSTALL_FILE_1="oracle-database-xe-18c-1.0-1.x86_64.rpm" \
```

Secondly, in the **Copy binaries** section, add `$INSTALL_FILE_1` to the `COPY` command.

```bash
COPY $CHECK_SPACE_FILE $RUN_FILE $PWD_FILE $CHECK_DB_FILE $CONF_FILE $INSTALL_FILE_1 $INSTALL_DIR/
```

Then replace the `yum install` with the following.

```bash
    yum -y install file openssl oracle-database-preinstall-18c && \
    yum -y localinstall ./$INSTALL_FILE_1 && \
```

Do not forget to put the downloaded rpm into the same folder of *Dockerfile.xe* file.

Execute the above docker build command again, it should be succeeded .

Open your terminal, run Oracle Database XE in a docker container.

```bash
docker run --name <container name> \
-p <host port>:1521 -p <host port>:5500 \
-e ORACLE_PWD=<your database passwords> \
-e ORACLE_CHARACTERSET=<your character set> \
-v [<host mount point>:]/opt/oracle/oradata \
oracle/database:18.4.0-xe
```

There is a sample of Docker compose file to run Oracle Database XE .

```yaml
version: "3.5" # specify docker-compose version, v3.5 is compatible with docker 17.12.0+

# Define the services/containers to be run
services:
  oracledb:
    image: oracle/database:18.4.0-xe
    environment:
      - "ORACLE_PWD:Passw0rd"
#      - "ORACLE_CHARACTERSET:AL32UTF8" # default is AL32UTF8
    volumes:
      - ./oradata:/opt/oracle/oradata # persistent oracle database data.
    ports:
      - 1521:1521 
      - 8080:8080 # apex
      - 5500:5500 # oemexpress
```

