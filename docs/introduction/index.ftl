<html>
<head>
  <title>Introduction</title>
  <meta name="layout" content="_layout/docs.html"/>
  <meta name="bread1" content="Introduction" href="/docs/introduction/"/>
  <template id="menuNav"><#include "/_layout/_docs_nav_intro.ftl"></template>
  <#assign introduction="active">
</head>
<body>
<h3><a href="why">Why Ebean exists</a></h3>
<p>
  Look at why does Ebean exists, how does it compare to JPA and Hibernate.
</p>

<h3><a href="ebeanserver">EbeanServer</a></h3>
<p>
  Introduction to EbeanServer and the concept of the <b>default server</b>.
</p>

<h3><a href="ebeanserver#ebean">Ebean</a></h3>
<p>
  Ebean as a <b>registry</b> of all the EbeanServer instances, convenience methods for the <b>default server</b>.
</p>

<h3><a href="serverconfig">ServerConfig</a></h3>
<p>
  Configuration used when creating EbeanServer instances.
</p>

<h3><a href="serverconfig">EbeanServerFactory</a></h3>
<p>
  Factory that takes a ServerConfig to create an EbeanServer instance.
</p>

<h3><a href="manifest">ebean.mf</a></h3>
<p>
  Manifest file controls the <b>enhancement</b> for Ebean. What packages are enhanced for
  a project and what enhancement features are turned on.
</p>

<@next_edit "Tooling" "/docs/tooling/" "/docs/tooling"/>
</body>
</html>
