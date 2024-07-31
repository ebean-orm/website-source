<nav class="side">
  <ul>
    <#include "/_nav/getting-started.ftl">
    <#include "/_nav/introduction.ftl">
    <@nav0 activeCheck="${n0_docs!''}" url="/docs" title="Documentation">
      <ul>
        <@nav1 activeCheck="${n1_bestPractice!''}" url="/docs/best-practice" title="Best practice">
          <ul class="nav nav-scroll">
            <@smallnav activeCheck="" url="#identity" title="Identity"/>
            <@smallnav activeCheck="" url="#kotlin-data-class" title="Kotlin data classes"/>
            <@smallnav activeCheck="" url="#list" title="List vs Set"/>
            <@smallnav activeCheck="" url="#join-column" title="@JoinColumn"/>
            <@smallnav activeCheck="" url="#column-name" title="@Column(name=...)"/>
            <@smallnav activeCheck="" url="#mapped-superclass" title="@MappedSuperclass"/>
            <@smallnav activeCheck="" url="#ddl-generation" title="DDL generation"/>
            <@smallnav activeCheck="" url="#not-null" title="NOT NULL"/>
            <@smallnav activeCheck="" url="#use-constructors" title="Use Constructors"/>
            <@smallnav activeCheck="" url="#getters-setters" title="Getters Setters"/>
            <@smallnav activeCheck="" url="#builder-pattern" title="Builder pattern"/>
            <@smallnav activeCheck="" url="#bulk-update" title="Bulk update queries"/>
            <@smallnav activeCheck="" url="#reference-beans" title="Reference beans"/>
            <@smallnav activeCheck="" url="#naming-entities" title="Naming entity beans"/>
            <@smallnav activeCheck="" url="#database-design-mindset" title="Database design mindset"/>
          </ul>
        </@nav1>
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
        <@nav1 activeCheck="${n1_transactions!''}" url="/docs/transactions" title="Transactions">
          <#include "/_nav/transactions.ftl">
        </@nav1>
        <@nav1 activeCheck="${n1_mapping!''}" url="/docs/mapping" title="Mapping">
          <#include "/_nav/mapping.ftl">
        </@nav1>
        <@nav1 activeCheck="${n1_dll!''}" url="/docs/ddl-generation" title="DDL & Migrations">
          <#include "/_nav/ddl.ftl">
        </@nav1>
        <@nav1 activeCheck="${n1_logging!''}" url="/docs/logging" title="Logging"/>
        <@nav1 activeCheck="${n1_testing!''}" url="/docs/testing" title="Testing">
            <#include "/_nav/testing.ftl">
        </@nav1>
        <@nav1 activeCheck="${n1_readreplicas!''}" url="/docs/read-replicas" title="Read Replicas"/>
        <@nav1 activeCheck="${n1_platforms!''}" url="/docs/database" title="Database platforms">
            <#include "/_nav/database-platforms.ftl">
        </@nav1>
        <@nav1 activeCheck="${n1_multiDatabase!''}" url="/docs/multi-database" title="Multiple databases">
          <#include "/_nav/multi-database.ftl">
        </@nav1>
        <@nav1 activeCheck="${n1_kotlin!''}" url="/docs/kotlin" title="Kotlin">
          <ul class="nav nav-scroll">
            <@smallnav activeCheck="" url="#constructors" title="Constructors"/>
            <@smallnav activeCheck="" url="#non-nullable" title="Non-nullable types"/>
            <@smallnav activeCheck="" url="#mapped-superclass" title="MappedSuperclass"/>
            <@smallnav activeCheck="" url="#oneToMany" title="@OneToMany"/>
          </ul>
        </@nav1>
        <li><a href="/docs/tuning">Tuning</a></li>
        <@nav1 activeCheck="${n1_features!''}" url="/docs/features" title="Features">
            <#include "/_nav/features.ftl">
        </@nav1>
      </ul>
    </@nav0>
    <@nav0 activeCheck="${n0_support!''}" url="/support" title="Getting help"/>
    <li class="nav0 ">
      <a target="_blank" href="/apidoc/13">API Javadoc</a>
    </li>
    <@nav0 activeCheck="${n0_videos!''}" url="/videos" title="Videos"/>
    <@nav0 activeCheck="${n0_upgrading!''}" url="/docs/upgrading" title="Upgrading"/>
    <@nav0 activeCheck="${n0_releases!''}" url="/releases" title="Releases"/>

  </ul>
</nav>
