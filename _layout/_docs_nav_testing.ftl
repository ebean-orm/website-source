
<@smallnav activeCheck="${testing!''}" url="/docs/testing" title="Ebean test"/>
<@smallnav activeCheck="${ddlMode!''}" url="/docs/testing/ddl-mode" title="DDL Mode"/>
<@smallnav activeCheck="${docker!''}" url="/docs/testing/docker" title="Docker">
  <ul class="nav">
    <li><a href="#startup">Startup</a></li>
    <li><a href="#shutdown">Shutdown</a></li>
    <li><a href="#not-docker">No Docker</a></li>
  </ul>
</@smallnav>
<@smallnav activeCheck="${platform!''}" url="/docs/testing/platform" title="Platform"/>
<@smallnav activeCheck="${currentUser!''}" url="/docs/testing/current-user-tenant" title="Current User & Tenant"/>

<@smallnav activeCheck="${testproperties!''}" url="/docs/testing/test-properties" title="Test properties"/>
<@smallnav activeCheck="${elastic!''}" url="/docs/testing/elasticsearch" title="ElasticSearch"/>
<@smallnav activeCheck="${postgres!''}" url="/docs/testing/postgres" title="Postgres">
<ul class="nav">
  <li><a href="#extensions">Extensions</a></li>
  <li><a href="#schema">Schema</a></li>
  <li><a href="#postgis">Postgis</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${mysql!''}" url="/docs/testing/mysql" title="MySql"/>
<@smallnav activeCheck="${sqlserver!''}" url="/docs/testing/sqlserver" title="SQL Server"/>
<@smallnav activeCheck="${mocki!''}" url="/docs/testing/mocki" title="Mocki Ebean"/>
<@smallnav activeCheck="${runner!''}" url="/docs/testing/script-runner" title="Script Runner"/>
