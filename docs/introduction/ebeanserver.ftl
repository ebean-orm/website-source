<html>
<head>
  <title>Introduction</title>
  <meta name="layout" content="_layout/docs.html"/>
  <meta name="bread1" content="Introduction" href="/docs/introduction/"/>
  <meta name="bread2" content="EbeanServer" href="/docs/introduction/"/>
  <template id="menuNav"><#include "/_layout/_docs_nav_intro.ftl"></template>
  <#assign ebeanserver="active">
</head>
<body>
<h2 id="ebeanserver" class="htop">EbeanServer</h2>
<p>
  The EbeanServer provides almost all of the functionality including <code>queries</code>, <code>saving</code>, <code>deleting</code>
  and <code>transactions</code>. It effectively provides all the functionality.
</p>
<p>
  A EbeanServer instance maps to a <b>single database</b> - there is effectively a one to one mapping of
  EbeanServer instance to database. If our application talks to many databases we can have many EbeanServer instances
  each with a unique name.
</p>
<p>
  Applications that only use a single database only have one instance of EbeanServer.
</p>
```java
// save customer to the database
Customer customer  = ...
ebeanServer.save(customer);
```

```java
// fetch some customers from the database

List<Customer> customers =
  ebeanServer.find(Customer.class)
  .where().eq("status", Customer.Status.NEW)
  .findList();
```

<h2 id="defaultserver" class="tg">Default EbeanServer</h2>
<p>
  We can define one of the EbeanServer instances to be the <b>default EbeanServer</b>. This is the
  <b>main</b> or <b>primary</b> EbeanServer instance that the application uses.
</p>
<p>
  Many applications only talk to one database and in that case there is only one EbeanServer instance and it
  is also the default server.
</p>


<h2 id="ebean" class="tg">Ebean</h2>
<ul>
  <li>Holds a <b>registry</b> of EbeanServer instances (keyed by name)</li>
  <li>Holds one EbeanServer instance known as the <b>default server</b></li>
  <li>Has <b>convenience</b> methods to operate on the default server</li>
</ul>
<p>&nbsp;</p>
<h4>Obtain the default EbeanServer</h4>
<p>
  When an EbeanServer instance is created it is registered with Ebean. We can use <code>Ebean</code> to obtain those
  EbeanServer instances by name and we can obtain the default server via <code>Ebean.getDefaultServer()</code>.
</p>
```java
// obtain the "default" server
EbeanServer server = Ebean.getDefaultServer();
```
<h4>Obtain a EbeanServer instance by name</h4>
<p>
  When there are many EbeanServer instances they are registered with Ebean with a <code>name</code> and we can use that
  to obtain them via Ebean.
</p>
```java
// obtain the HR server by name
EbeanServer hrServer = Ebean.getServer("hr");
```

<h4>Convenience methods</h4>
<p>
  Ebean has static convenience methods that proxy through to the default server.
</p>

```java
Customer customer  = ...

// save customer to the database
// using the 'default' ebeanServer
Ebean.save(customer);

// which is the same as
EbeanServer defaultServer = Ebean.getDefaultServer()
defaultServer.save(customer);
```

<h4>Ebean is optional</h4>
<p>
  Note that you don't have to use the Ebean singleton in your application at all - it's use is completely optional.
  Instead we can create the EbeanServer instance(s) and <code>inject</code> them where needed - we typically do this
  using <code>Spring</code> or <code>Guice</code> or a similar DI framework.
</p>
<p>
  When we do this (inject EbeanServer and don't use the Ebean singleton) we will likely have the application
  code following a <a href="/docs/codestyle">DI / Repository pattern</a> convention.
</p>

<h2 id="global" class="tg">Global state</h2>
<p>
  The Ebean singleton has static methods which refer to the <b>default server</b> and we could reasonably
  say this represents <b>global state</b>. Generally this is considered <b><a href="/docs/testing/">bad for
  testing</a></b>.
</p>
<p>
  Ebean provides support for mocking the EbeanServer API even when accessed via the Ebean singleton using
  <a href="/docs/testing/mocki">Mocki Ebean</a>.
</p>
<p>
  Also note that the <b>database</b> itself represents <b>global state</b> and from a testing
  perspective there are many reasons to run tests against the same database platform (Postgres, MySql, Oracle etc)
  that we are targeting in production. We can do this nicely using <b>docker</b>.
</p>
<p>

</p>

<h2 id="model" class="tg">Model and Finder</h2>
<p>
  Due to the way we can access the <b>default server</b> via the Ebean singleton - a coding style / approach has
  evolved that uses <code>io.ebean.Model</code> and <code>io.ebean.Finder</code> to provide an active record
  style approach.
</p>
<p>
  We discuss the option of using Model and Finder in more detail at <a href="/docs/codestyle">coding style options</a>.
</p>

<@next_edit "ServerConfig" "serverconfig" "/docs/introduction/ebeanserver.html"/>

</body>
</html>
