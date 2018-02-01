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
<h2 id="ebeanserver">EbeanServer</h2>
<p>
  The EbeanServer provides the main API for creating <code>queries</code>, <code>saving</code>, <code>deleting</code>,
  <code>transactions</code> etc. It effectively provides all the functionality.
</p>
<p>
  A EbeanServer instance maps to a <code>single database</code> - there is effectively a one to one mapping of
  EbeanServer instance to database. If our application talks to many databases we can have many EbeanServer instances
  each with a unique name.
</p>
<p>
  Applications that only use a single database only have one instance of EbeanServer.
</p>
<pre content="java">
// save customer to the database
Customer customer  = ...
ebeanServer.save(customer);
</pre>

<pre content="java">{@code
// fetch some customers from the database

List<Customer> customers =
  ebeanServer.find(Customer.class)
  .where().eq("status", Customer.Status.NEW)
  .findList();
}</pre>

<h2 id="defaultserver">The "default" EbeanServer</h2>
<p>
  We can define one of the EbeanServer instances to be the <code>default EbeanServer</code>. This is the
  <code>main</code>
  or <code>primary</code> EbeanServer instance that the application uses.
</p>

<h2 id="ebean">Ebean</h2>
<p>
  When an EbeanServer instance is created it is registered with Ebean. We can use <code>Ebean</code> to obtain those
  EbeanServer instances by name and we can obtain the default server via <code>Ebean.getDefaultServer()</code>.
</p>
<pre content="java">
// obtain the "default" server
EbeanServer server = Ebean.getDefaultServer();
</pre>
<p>
  When there are many EbeanServer instances they are registered with Ebean with a <code>name</code> and we can use that
  to obtain them via Ebean.
</p>
```java
// obtain the HR server by name
EbeanServer hrServer = Ebean.getServer("hr");
```
<p>
  Ebean provides a convenient way to call methods on the default EbeanServer. The <code>methods on Ebean
  proxy through to the underlying default EbeanServer instance</code>.
</p>


<h3>Ebean convenience methods</h3>
<p>
  Ebean has static convenience methods that proxy through to the default server.
</p>

```
<pre content="java">
Customer customer  = ...

// save customer to the database
// using the 'default' ebeanServer
Ebean.save(customer);

// which is the same as
EbeanServer defaultServer = Ebean.getDefaultServer()
defaultServer.save(customer);
</pre>

<h3>Ebean is optional</h3>
<p>
  Note that you don't have to use the Ebean singleton in your application at all - it's use is completely optional.
  Instead we can create the EbeanServer instance(s) and <code>inject</code> them where needed - we typically do this
  using <code>Spring</code> or <code>Guice</code> or a similar DI framework.
</p>
<p>
  When we do this (inject EbeanServer and don't use the Ebean singleton) we will likely have the application
  code following a <a href="/docs/codestyle">DI / Repository pattern</a> convention.
</p>

<h2 id="global">Global state</h2>
<p>
  The Ebean singleton has static methods which refer to the <code>default server</code> and we could reasonably
  say this represents <code>global state</code>. Generally this is considered <code><a href="/docs/testing/">bad for
  testing</a></code>.
</p>
<p>
  Ebean provides support for mocking the EbeanServer API even when accessed via the Ebean singleton using
  <a href="/docs/testing/mocki">Mocki Ebean</a>.
</p>
<p>
  Also note that the <code>database</code> itself represents <code>global state</code> and from a testing
  perspective there are many reasons to run tests against the same database platform (Postgres, MySql, Oracle etc)
  that we are targeting in production. We can do this nicely using <code>docker</code>.
</p>
<p>

</p>

<h2 id="model">Optional use of Model and Finder</h2>
<p>
  Due to the way we can access the <code>default server</code> via the Ebean singleton - a coding style / approach has
  evolved that uses <code>io.ebean.Model</code> and <code>io.ebean.Finder</code> to provide an active record
  style approach.
</p>
<p>
  We discuss the option of using Model and Finder in more detail at <a href="/docs/codestyle">coding style options</a>.
</p>

<@next_edit "ServerConfig" "serverconfig" "/docs/introduction/ebeanserver.html"/>

</body>
</html>
