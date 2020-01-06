<nav class="side">
  <ul>
    <@nav0 activeCheck="${n0_start!''}" url="/docs/getting-started" title="Getting started">
      <ul>
      <@nav1 activeCheck="${n1_ide!''}" url="/docs/getting-started/#ide" title="IDE Plugin"/>
      <@nav1 activeCheck="${n1_cli!''}" url="/docs/getting-started/cli-tool" title="CLI Tool"/>
      <@nav1 activeCheck="${n1_maven!''}" url="/docs/getting-started/maven" title="Maven"/>
      <@nav1 activeCheck="${n1_gradle!''}" url="/docs/getting-started/gradle" title="Gradle"/>
      <@nav1 activeCheck="${n1_test!''}" url="/docs/getting-started/ebean-test" title="Test setup"/>
      </ul>
    </@nav0>
    <@nav0 activeCheck="${n0_intro!''}" url="/docs/intro" title="Introduction">
    </@nav0>
    <@nav0 activeCheck="${n0_docs!''}" url="/docs" title="Documentation">
      <ul>
        <@nav1 activeCheck="${n1_query!''}" url="/docs/query" title="Query">
          <#include "/_nav/query.ftl">
        </@nav1>
        <@nav1 activeCheck="${sect_persist!''}" url="/docs/persist" title="Persist"/>
        <@nav1 activeCheck="${sect_transactions!''}" url="/docs/transactions" title="Transactions"/>
        <li><a href="/docs/mapping">Mapping</a></li>
        <li><a href="/docs/ddl">DDL Generation</a></li>
        <li><a href="/docs/ddl/dbmigration">DB Migration</a></li>
        <li><a href="/docs/logging">Logging</a></li>
        <li><a href="/docs/testing">Testing</a></li>
        <li><a href="/docs/tuning">Tuning</a></li>
        <li><a href="/docs/features">Features</a></li>
        <li><a href="/docs/upgrading">Upgrading</a></li>
      </ul>
    </@nav0>
  </ul>
</nav>
