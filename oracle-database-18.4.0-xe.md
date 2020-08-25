# Building a custom Oracle Database XE Docker Image

In these days, I was trying to connect an Oracle Database instance in my sample codes, but I found preparing it is really not easy.

Installing and configuring a complete full-featured Oracle Database Standard Edition(SE) or Enterprise Edition(EE) will waste your disk space and time. In before experience, I would like to run a dependent database server in Docker and focus on the application development.

Oracle has published official Docker Images of the  SE and EE  through Docker hub and its self-host [Container registry](https://container-registry.oracle.com/), but there is no a public XE version there. Fortunately Oracle maintains a [oracle/docker-images](https://github.com/oracle/docker-images/) repo on Github which contains Dockerfiles for almost all Oracle products, including a XE version of Oracle Database.

Navigate to [OracleDatabase/SingleInstance/dockerfiles/18.4.0](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance/dockerfiles/18.4.0), fetch all files into your local disc, Let's build it for yourself.

Make sure you have installed Docker in your system.  For Windows/MacOS users, install the latest Docker for Windows/MacOS.

Enter the folder which contains the Dockerfile resource you have downloaded, then run the following command to build the Docker image.

```bash
docker build -t oracle/database:18.4.0-xe -f Dockerfile.xe .
```

Generally it will take some minutes to complete.

Unluckily it failed again and again here when fetching the oracle-database rpm file in my machine. To overcome this barrier, I decided to download the rpm file manually using an external download tool, then perform a small modification on the original *Dockerfile.xe* to make it install the local rpm instead of the remote URL.

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

Check the complete modified Dockerfile from this [gist](https://gist.github.com/hantsy/57ed22ea775763ceceaebaa01182592b). And do not forget to put the downloaded rpm into the same folder of *Dockerfile.xe* file.

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
Alternatively, run it from a Docker Compose file. There is a Docker compose sample file to run Oracle Database XE .

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

Start up an Oracle Database instance.

```bash
>docker-compose up
Creating network "oracle-jdbc-ds-war_default" with the default driver
Creating oracle-jdbc-ds-war_oracledb_1 ... done
Attaching to oracle-jdbc-ds-war_oracledb_1
oracledb_1  | ORACLE PASSWORD FOR SYS AND SYSTEM: 11bdb39b98599a8b
oracledb_1  | Specify a password to be used for database accounts. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9]. Note that the same password will be used for SYS, SYSTEM and PDBADMIN accounts:
oracledb_1  | Confirm the password:
oracledb_1  | Configuring Oracle Listener.
oracledb_1  | Listener configuration succeeded.
oracledb_1  | Configuring Oracle Database XE.
oracledb_1  | Enter SYS user password:
oracledb_1  | *****************
oracledb_1  | Enter SYSTEM user password:
oracledb_1  | *******************
oracledb_1  | Enter PDBADMIN User Password:
oracledb_1  | ***************
oracledb_1  | Prepare for db operation
oracledb_1  | 7% complete
oracledb_1  | Copying database files
oracledb_1  | 29% complete
oracledb_1  | Creating and starting Oracle instance
oracledb_1  | 30% complete
oracledb_1  | 31% complete
oracledb_1  | 34% complete
oracledb_1  | 38% complete
oracledb_1  | 41% complete
oracledb_1  | 43% complete
oracledb_1  | Completing Database Creation
oracledb_1  | 47% complete
oracledb_1  | 50% complete
oracledb_1  | Creating Pluggable Databases
oracledb_1  | 54% complete
oracledb_1  | 71% complete
oracledb_1  | Executing Post Configuration Actions
oracledb_1  | 93% complete
oracledb_1  | Running Custom Scripts
oracledb_1  | 100% complete
oracledb_1  | Database creation complete. For details check the logfiles at:
oracledb_1  |  /opt/oracle/cfgtoollogs/dbca/XE.
oracledb_1  | Database Information:
oracledb_1  | Global Database Name:XE
oracledb_1  | System Identifier(SID):XE
oracledb_1  | Look at the log file "/opt/oracle/cfgtoollogs/dbca/XE/XE.log" for further details.
oracledb_1  |
oracledb_1  | Connect to Oracle Database using one of the connect strings:
oracledb_1  |      Pluggable database: 7044c6afe68b/XEPDB1
oracledb_1  |      Multitenant container database: 7044c6afe68b
oracledb_1  | Use https://localhost:5500/em to access Oracle Enterprise Manager for Oracle Database XE
oracledb_1  | The Oracle base remains unchanged with value /opt/oracle
oracledb_1  | #########################
oracledb_1  | DATABASE IS READY TO USE!
oracledb_1  | #########################
oracledb_1  | The following output is now a tail of the alert.log:
oracledb_1  | 2020-08-11T13:03:34.791118+00:00
oracledb_1  | XEPDB1(3):Resize operation completed for file# 10, old size 358400K, new size 368640K
oracledb_1  | 2020-08-11T13:03:37.308649+00:00
oracledb_1  | XEPDB1(3):CREATE SMALLFILE TABLESPACE "USERS" LOGGING  DATAFILE  '/opt/oracle/oradata/XE/XEPDB1/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED  EXTENT MANAGEMENT LOCAL  SEGMENT SPACE MANAGEMENT  AUTO
oracledb_1  | XEPDB1(3):Completed: CREATE SMALLFILE TABLESPACE "USERS" LOGGING  DATAFILE  '/opt/oracle/oradata/XE/XEPDB1/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED  EXTENT MANAGEMENT LOCAL  SEGMENT SPACE MANAGEMENT  AUTO
oracledb_1  | XEPDB1(3):ALTER DATABASE DEFAULT TABLESPACE "USERS"
oracledb_1  | XEPDB1(3):Completed: ALTER DATABASE DEFAULT TABLESPACE "USERS"
oracledb_1  | 2020-08-11T13:03:38.271246+00:00
oracledb_1  | ALTER PLUGGABLE DATABASE XEPDB1 SAVE STATE
oracledb_1  | Completed: ALTER PLUGGABLE DATABASE XEPDB1 SAVE STATE
```
If it is the first time to run this command, it will take some time to prepare an Oracle instance for you. If you do not set a  password in the *docker-compose.yaml* file, it will generate one for you. 

When you see the **DATABASE IS READY TO USE!** is displayed, the database is ready for use.

Check the stauts of the running Docker container.

```bash
 docker ps
 CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS                    PORTS                              NAMES
 7044c6afe68b        oracle/database:18.4.0-xe   "/bin/sh -c 'exec $O…"   12 minutes ago      Up 12 minutes (healthy)   0.0.0.0:1521->1521/tcp, 0.0.0.0:5500->5500/tcp, 0.0.0.0:8080->8080/tcp   oracle-jdbc-ds-war_oracledb_1
```

Anytime you can change password on an running Oracle instance.

```bash
> docker exec 7044c6afe68b ./setPassword.sh "Passw0rd"
The Oracle base remains unchanged with value /opt/oracle

SQL*Plus: Release 18.0.0.0.0 - Production on Tue Aug 11 13:14:05 2020
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL>
User altered.

SQL>
User altered.

SQL>
Session altered.

SQL>
User altered.

SQL> Disconnected from Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0
```
