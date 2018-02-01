<html>
<head>
  <title>Introduction</title>
  <meta name="layout" content="_layout/docs.html"/>
  <meta name="bread1" content="Introduction" href="/docs/introduction/"/>
  <meta name="bread2" content="ServerConfig" href="/docs/introduction/"/>
  <template id="menuNav"><#include "/_layout/_docs_nav_intro.ftl"></template>
  <#assign serverconfig="active">
</head>
<body>
<h2>ServerConfig and EbeanServerFactory</h2>
<p>
  <code>ServerConfig</code> is a bean that has all the configuration options used to create
  EbeanServer instances.
</p>
<p>
  We pass a <code>ServerConfig</code> instance to <code>EbeanServerFactory</code> to programmatically
  create an EbeanServer instance.
</p>
```java

ServerConfig config = new ServerConfig();

// set configuration options
config.set...
...
// and/or load configuration properties file
config.loadFromProperties();

// create the EbeanServer instance
EbeanServer server = EbeanServerFactory.create(config);
```
<div class="next pull-right">
  <a href="manifest" class="btn btn-info">Next: Ebean.mf</a>
</div>
</body>
</html>
