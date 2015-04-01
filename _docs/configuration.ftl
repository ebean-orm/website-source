<div class="bs-docs-section">
<h1 id="configuration" class="page-header">Bootstrap</h1>



<#-------------------------------------------------------------------------------------------------->
<h2 id="properties_config">ebean.properties configuration</h2>

<p>Create an ebean.properties file and put it in your classpath or working directory. You can use the example below as a starting point.</p>

<p>
You need to change the DataSource parameters to suite your own environment.
</p>

```properties
# -------------------------------------------------------------
# Load (Dev/Test/Prod) properties external to your war/jar
# -------------------------------------------------------------
# You can use load.properties to load the properties from a
# file external to your war/jar.
#load.properties.override=$\{CATALINA_HOME}/conf/myapp.ebean.properties


ebean.ddl.generate=false
ebean.ddl.run=false

ebean.debug.sql=true
ebean.debug.lazyload=false


# -------------------------------------------------------------
# Transaction Logging
# -------------------------------------------------------------

# Use java util logging to log transaction details
#ebean.loggingToJavaLogger=true

# General logging level: (none, explicit, all)
ebean.logging=all

# Sharing log files: (none, explicit, all)
ebean.logging.logfilesharing=all

# location of transaction logs
ebean.logging.directory=logs
#ebean.logging.directory=$\{catalina.base}/logs/trans

# Specific Log levels (none, summary, binding, sql)
ebean.logging.iud=sql
ebean.logging.query=sql
ebean.logging.sqlquery=sql

ebean.logging.txnCommit=none

# -------------------------------------------------------------
# DataSources (If using default Ebean DataSourceFactory)
# -------------------------------------------------------------
# You can specify many DataSources (one per EbeanServer)  and
# one of them is defined as the default/primary DataSource

# specify the default/primary DataSource
datasource.default=h2

datasource.h2.username=sa
datasource.h2.password=
datasource.h2.databaseUrl=jdbc:h2:mem:tests;DB_CLOSE_DELAY=-1
datasource.h2.databaseDriver=org.h2.Driver
datasource.h2.minConnections=1
datasource.h2.maxConnections=25
datasource.h2.heartbeatsql=select 1
datasource.h2.isolationlevel=read_committed

datasource.mysql.username=test
datasource.mysql.password=test
datasource.mysql.databaseUrl=jdbc:mysql://127.0.0.1:3306/test
datasource.mysql.databaseDriver=com.mysql.jdbc.Driver
datasource.mysql.minConnections=1
datasource.mysql.maxConnections=25
#datasource.mysql.heartbeatsql=select 1
datasource.mysql.isolationlevel=read_committed

#datasource.ora.username=test
#datasource.ora.password=test
#datasource.ora.databaseUrl=jdbc:oracle:thin:@127.0.0.1:1521:XE
#datasource.ora.databaseDriver=oracle.jdbc.driver.OracleDriver
#datasource.ora.minConnections=1
#datasource.ora.maxConnections=25
#datasource.ora.heartbeatsql=select count(*) from dual
#datasource.ora.isolationlevel=read_committed

#datasource.pg.username=test
#datasource.pg.password=test
#datasource.pg.databaseUrl=jdbc:postgresql://127.0.0.1:5433/test
#datasource.pg.databaseDriver=org.postgresql.Driver
#datasource.pg.heartbeatsql=select 1
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="programmatic_config">Programmatic configuration</h2>
<p>
You can programmatically build EbeanServer instances. ServerConfig is used to collect configuration settings and then passed to EbeanServerFactory to create the actual instance.
</p>
<p>
Note: When you use the Ebean singleton with a ebean.properties file it internally will create a ServerConfig, populate it from settings in the ebean.properties file and call EbeanServerFactory much like the code below.
</p>

```java
// programmatically build a EbeanServer instance
// specify the configuration...

ServerConfig config = new ServerConfig();
config.setName("pgtest");

// Define DataSource parameters
DataSourceConfig postgresDb = new DataSourceConfig();
postgresDb.setDriver("org.postgresql.Driver");
postgresDb.setUsername("test");
postgresDb.setPassword("test");
postgresDb.setUrl("jdbc:postgresql://127.0.0.1:5432/test");
postgresDb.setHeartbeatSql("select count(*) from t_one");

config.setDataSourceConfig(postgresDb);

// specify a JNDI DataSource
// config.setDataSourceJndiName("someJndiDataSourceName");

// set DDL options...
config.setDdlGenerate(true);
config.setDdlRun(true);

config.setDefaultServer(false);
config.setRegister(false);


// automatically determine the DatabasePlatform
// using the jdbc driver
// config.setDatabasePlatform(new PostgresPlatform());

// specify the entity classes (and listeners etc)
// ... if these are not specified Ebean will search
// ... the classpath looking for entity classes.
config.addClass(Order.class);
config.addClass(Customer.class);
...

// specify jars to search for entity beans
config.addJar("someJarThatContainsEntityBeans.jar");

// create the EbeanServer instance
EbeanServer server = EbeanServerFactory.create(config);
```

<h2 id="logging">Logging</h2>

<p>Ebean uses <a href="http://www.slf4j.org/">SLF4J</a> for logging.</p>

```xml
<!-- SQL and bind values -->
<logger name="org.avaje.ebean.SQL" level="TRACE"/>
<!-- Transaction Commit and Rollback events -->
<logger name="org.avaje.ebean.TXN" level="TRACE"/>
<!-- Summary level details -->
<logger name="org.avaje.ebean.SUM" level="TRACE"/>
```

<p>
In your early stages of using Ebean you should find where the transaction logs are going
so that you can see exactly what Ebean is doing.
</p>

<p>...(under construction)... would be good to give full details on how to setup logging</p>

</div>
