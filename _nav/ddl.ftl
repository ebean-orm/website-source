<ul>
  <@nav1 activeCheck="${n1_ddlcreateall!''}" url="/docs/ddl-generation" title="DDL Generation">
    <ul class="nav nav-scroll">
      <@smallnav activeCheck="" url="#test-config" title="Using ebean-test"/>
      <@smallnav activeCheck="" url="#properties" title="Using properties"/>
      <@smallnav activeCheck="" url="#create-all" title="db-create-all.sql"/>
      <@smallnav activeCheck="" url="#initSql" title="initSql"/>
      <@smallnav activeCheck="" url="#seedSql" title="seedSql"/>
    </ul>
  </@nav1>
  <@nav1 activeCheck="${n1_extraddl!''}" url="/docs/extra-ddl" title="Extra DDL">
    <ul class="nav nav-scroll">
      <@smallnav activeCheck="" url="#views" title="Views"/>
      <@smallnav activeCheck="" url="#procedures" title="Stored procedures"/>
      <@smallnav activeCheck="" url="#any" title="Any DDL"/>
      <@smallnav activeCheck="" url="#platforms" title="Platform specific DDL"/>
    </ul>
  </@nav1>
  <@nav1 activeCheck="${n1_dbmigration!''}" url="/docs/db-migrations" title="DB Migrations">
    <ul class="nav nav-scroll">
      <@smallnav activeCheck="" url="#generate" title="Generate a Migration"/>
      <@smallnav activeCheck="" url="#run" title="Run migrations"/>
    </ul>
  </@nav1>
</ul>
