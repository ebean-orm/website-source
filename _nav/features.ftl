<ul class="nav">
  <@smallnav activeCheck="${n2_l2cache!''}" url="/docs/features/l2cache" title="L2 Cache">
  <ul class="nav">
      <#include "/_nav/features_l2cache.ftl">
  </ul>
  </@smallnav>
  <@smallnav activeCheck="" url="/docs/features/elasticsearch" title="Elasticsearch"/>

  <@smallnav activeCheck="${jsonindb!''}" url="/docs/features/json-in-db" title="@DbJson"/>
  <@smallnav activeCheck="${softdelete!''}" url="/docs/features/softdelete" title="Soft Delete"/>
  <@smallnav activeCheck="${n2_encryption!''}" url="/docs/features/encryption" title="Encryption">
    <ul class="nav nav-scroll">
        <@smallnav activeCheck="" url="#client-encryption" title="Client side"/>
        <@smallnav activeCheck="" url="#db-encryption" title="Database side"/>
        <@smallnav activeCheck="" url="#types" title="Supported types"/>
        <@smallnav activeCheck="" url="#limitations" title="Limitations"/>
        <@smallnav activeCheck="" url="#configuration" title="Configuration"/>
        <@smallnav activeCheck="" url="#internals" title="Internals"/>
    </ul>
  </@smallnav>

  <@smallnav activeCheck="${who!''}" url="/docs/features/who" title="@WhoModified / @WhoCreated"/>

  <@smallnav activeCheck="${history!''}" url="/docs/features/history" title="SQL2011 History"/>
  <@smallnav activeCheck="${changelog!''}" url="/docs/features/changelog" title="ChangeLog"/>
  <@smallnav activeCheck="${readaudit!''}" url="/docs/features/readauditing" title="Read auditing">
    <ul class="nav nav-scroll">
        <@smallnav activeCheck="" url="#limitations" title="Limitations"/>
        <@smallnav activeCheck="" url="#getting-started" title="Getting started"/>
        <@smallnav activeCheck="" url="#readAuditLogger" title="ReadAuditLogger"/>
        <@smallnav activeCheck="" url="#setDisableReadAuditing" title="Disable for query"/>
    </ul>
  </@smallnav>
  <@smallnav activeCheck="${eventlistening!''}" url="/docs/features/eventlistening" title="Event Listening">
    <ul class="nav nav-scroll">
        <@smallnav activeCheck="" url="#jpa" title="JPA annotations, @PostUpdate etc"/>
        <@smallnav activeCheck="" url="#beanPersistController" title="BeanPersistController"/>
        <@smallnav activeCheck="" url="#beanPersistListener" title="BeanPersistListener"/>
    </ul>
  </@smallnav>

</ul>
