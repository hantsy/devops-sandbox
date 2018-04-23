# Run MS SQL Server in Docker

The official MS SQL Server for linux docker: https://hub.docker.com/r/microsoft/mssql-server-linux/

Run MS SQL server in docker.

```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=<YourStrong!Passw0rd>' -p 1433:1433 -d microsoft/mssql-server-linux:latest
```

By default `MSSQL_PID=Developer`.

Run an express edition instead.

```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=<YourStrong!Passw0rd>' -e 'MSSQL_PID=Express' -p 1433:1433 -d microsoft/mssql-server-linux:latest
```

Check the running Docker.

```
docker ps -a
CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS              PORTS                    NAMES
d57a68615db8        microsoft/mssql-server-linux:latest   "/opt/mssql/bin/sqls…"   2 hours ago         Up 2 hours          0.0.0.0:1433->1433/tcp   sql1
```

Change password,

```
docker exec -it <container id | container name> /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P '<YourStrong!Passw0rd>' \
   -Q 'ALTER LOGIN SA WITH PASSWORD="<YourNewStrong!Passw0rd>"'
```   

Connect to MS SQL Server.

```
docker exec -it <container name> "bash"

# enter docker console.
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P '<YourNewStrong!Passw0rd>'

```

Test database.

Create a new database.

```
>CREATE DATABASE TestDB
>SELECT Name from sys.Databases
>GO
```

Insert some data.

```
>USE TestDB
>CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)
>INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
>GO
```

Select data.

```
>SELECT * FROM Inventory WHERE quantity > 152;
>GO
```

Quit sql console.

```
>QUIT
```



