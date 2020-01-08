<li><a href="#ebean-test">ebean-test</a></li>
<li><a href="#ddlmode">DDL Mode</a></li>
<#--<@smallnav activeCheck="${testing!''}" url="#" title="ebean-test"/>-->
<#--<@smallnav activeCheck="${ddlMode!''}" url="#ddl-mode" title="DDL Mode"/>-->
<@smallnav activeCheck="${docker!''}" url="#docker" title="Docker"/>
<@smallnav activeCheck="${docker!''}" url="#container-startup" title="Container startup"/>
<@smallnav activeCheck="${docker!''}" url="#container-shutdown" title="Container shutdown"/>
<@smallnav activeCheck="${docker!''}" url="#not-docker" title="Not using docker"/>

<@smallnav activeCheck="${platform!''}" url="#platform" title="Platform"/>
<@smallnav activeCheck="${currentUser!''}" url="#current-user-tenant" title="Current User & Tenant"/>

<@smallnav activeCheck="${testproperties!''}" url="#test-properties" title="Test properties"/>
<@smallnav activeCheck="${elastic!''}" url="#elasticsearch" title="ElasticSearch"/>
<@smallnav activeCheck="${postgres!''}" url="#postgres" title="Postgres">
<ul class="nav nav-scroll">
  <li><a href="#extensions">Extensions</a></li>
  <li><a href="#schema">Schema</a></li>
  <li><a href="#postgis">Postgis</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${mysql!''}" url="#mysql" title="MySql"/>
<@smallnav activeCheck="${sqlserver!''}" url="#sqlserver" title="SQL Server"/>
<@smallnav activeCheck="${mocki!''}" url="#mocki" title="Mocki Ebean"/>
<@smallnav activeCheck="${runner!''}" url="#script-runner" title="Script Runner"/>
