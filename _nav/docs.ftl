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
        <li><a href="/docs/ddl">DDL Generation</a></li>
        <li><a href="/docs/ddl/dbmigration">DB Migration</a></li>
        <li><a href="/docs/logging">Logging</a></li>
        <li><a href="/docs/testing">Testing</a></li>
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
