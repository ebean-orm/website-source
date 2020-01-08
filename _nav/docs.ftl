<nav class="side">
  <ul>
    <#include "/_nav/getting-started.ftl">
    <#include "/_nav/introduction.ftl">
    <@nav0 activeCheck="${n0_docs!''}" url="/docs" title="Documentation">
      <ul>
        <#if n1_query_find??>
          <@nav1 activeCheck="true" url="/docs/query" title="Query">
            <#include "/_nav/query-find.ftl">
          </@nav1>
        <#elseif n1_query_options??>
          <@nav1 activeCheck="true" url="/docs/query" title="Query">
          <#include "/_nav/query-options.ftl">
          </@nav1>
        <#elseif n1_query??>
          <@nav1 activeCheck="true" url="/docs/query" title="Query">
          <#include "/_nav/query.ftl">
          </@nav1>
        <#else>
          <@nav1 activeCheck="${n1_query_index!''}" url="/docs/query" title="Query"/>
        </#if>
        <@nav1 activeCheck="${sect_persist!''}" url="/docs/persist" title="Persist"/>
        <@nav1 activeCheck="${sect_transactions!''}" url="/docs/transactions" title="Transactions"/>
        <li><a href="/docs/mapping">Mapping</a></li>
        <@nav1 activeCheck="${n1_ddlcreateall!''}" url="/docs/ddl-generation" title="DDL Generation">
          <ul class="nav nav-scroll">
            <@smallnav activeCheck="" url="#test-config" title="Using ebean-test"/>
            <@smallnav activeCheck="" url="#properties" title="Using properties"/>
            <@smallnav activeCheck="" url="#create-all" title="db-create-all.sql"/>

            <@smallnav activeCheck="" url="#initSql" title="initSql"/>
            <@smallnav activeCheck="" url="#seedSql" title="seedSql"/>
          </ul>
        </@nav1>
        <@nav1 activeCheck="${n1_dbmigration!''}" url="/docs/db-migrations" title="DB Migrations">
          <ul class="nav nav-scroll">
            <@smallnav activeCheck="" url="#generate" title="Generate a Migration"/>
            <@smallnav activeCheck="" url="#run" title="Run migrations"/>
          </ul>
        </@nav1>
        <@nav1 activeCheck="${n1_logging!''}" url="/docs/logging" title="Logging"/>
        <@nav1 activeCheck="${n1_testing!''}" url="/docs/testing" title="Testing">
          <ul class="nav nav-scroll">
            <#include "/_nav/testing.ftl">
          </ul>
        </@nav1>
        <li><a href="/docs/tuning">Tuning</a></li>
        <li><a href="/docs/features">Features</a></li>
      </ul>
    </@nav0>
    <@nav0 activeCheck="${n0_support!''}" url="/support" title="Getting help"/>
    <li class="nav0 ">
      <a target="_blank" href="/apidoc/11">API Javadoc</a>
    </li>
    <@nav0 activeCheck="${n0_videos!''}" url="/videos" title="Videos"/>
    <@nav0 activeCheck="${n0_upgrading!''}" url="/docs/upgrading" title="Upgrading"/>
    <@nav0 activeCheck="${n0_releases!''}" url="/releases" title="Releases"/>

  </ul>
</nav>
