

<@smallnav activeCheck="${json!''}" url="/docs/features/json" title="JSON"/>
<@smallnav activeCheck="${jsonindb!''}" url="/docs/features/json-in-db" title="JSON in DB">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#mapping">Mapping</a></li>
  <li><a href="#save-find">Save and Find</a></li>
  <li><a href="#query">Query expressions</a></li>
  <li><a href="#postgres">Postgres</a></li>
  <li><a href="#oracle">Oracle</a></li>
  <li><a href="#raw">Raw expression</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${eventlistening!''}" url="/docs/features/eventlistening" title="Event listening">
</@smallnav>

<@smallnav activeCheck="${softdelete!''}" url="/docs/features/softdelete" title="Soft Delete">
<ul class="nav">
  <li><a href="#softdelete">@SoftDelete</a></li>
  <li><a href="#delete">Delete</a></li>
  <li><a href="#deletepermanent">Delete Permanent</a></li>
  <li><a href="#cascade">Cascading behavior</a></li>
  <li><a href="#query">Query (normal)</a></li>
  <li><a href="#includeSoftDeletes">Query - includeSoftDeletes</a></li>
  <li><a href="#notifications">Notifications</a></li>
  <li><a href="#changelog">Change Log</a></li>
</ul>
</@smallnav>

<@smallnav activeCheck="${who!''}" url="/docs/features/who" title="Who Created Modified">
</@smallnav>

<@smallnav activeCheck="${readaudit!''}" url="/docs/features/readauditing" title="Read Auditing">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#caveats">Caveats</a></li>
  <li><a href="#getting-started">Getting started</a></li>
  <li><a href="#query">Query setDisableReadAuditing()</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${changelog!''}" url="/docs/features/changelog" title="Change Log">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#caveats">Caveats</a></li>
  <li><a href="#getting-started">Getting started</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${history!''}" url="/docs/features/history" title="History SQL2011">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#history-tables">History tables</a></li>
  <li><a href="#change-log">Compared to Change Log</a></li>
  <li><a href="#history">@History</a></li>
  <li><a href="#history-exclude">@HistoryExclude</a></li>
  <li><a href="#manytomany">ManyToMany intersection</a></li>
  <li><a href="#as-of-query">As of query</a></li>
  <li><a href="#versions-between-query">Versions between</a></li>
  <li><a href="#who-when">Who and When</a></li>
  <li><a href="#postgres">Postgres</a></li>
  <li><a href="#mysql">MySql</a></li>
  <li><a href="#oracle">Oracle</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${draftable!''}" url="/docs/features/draftable" title="Draftable">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#mapping">Mapping</a></li>
  <li><a href="#query-as-draft">Query As Draft</a></li>
  <li><a href="#publish">Publish</a></li>
  <li><a href="#draft-restore">Draft Restore</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${l2caching!''}" url="/docs/features/l2caching" title="L2 caching">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#l2-l3">L2/local and L3/remote</a></li>
  <li><a href="#read-consistency">Read consistency</a></li>
  <li><a href="#table-iud-invalidation">Table IUD invalidation</a></li>
  <li><a href="#bean-iud-invalidation">Bean IUD invalidation</a></li>
  <li><a href="#read-only-instances">Read only instances</a></li>
  <li><a href="#shared-instances">Shared instances</a></li>
  <li><a href="#external-mods">External modification</a></li>
  <li><a href="#cachestrategy">@CacheStrategy</a></li>
  <li><a href="#query-bean-cache">Query - bean cache</a></li>
  <li><a href="#query-query-cache">Query - query cache</a></li>
</ul>
</@smallnav>

<@smallnav activeCheck="${elastic!''}" url="/docs/features/elasticsearch" title="ElasticSearch">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#mapping">Mapping</a></li>
</ul>
</@smallnav>

<@smallnav activeCheck="${jvmlanguages!''}" url="/docs/features/jvmlanguages" title="JVM Languages">
<ul class="nav">
  <li><a href="#groovy">Groovy</a></li>
  <li><a href="#scala">Scala</a></li>
</ul>
</@smallnav>

<@smallnav activeCheck="${clustering!''}" url="/docs/features/clustering" title="Clustering">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#container">Container</a></li>
  <li><a href="#l2cache-invalidation">L2 cache invalidation</a></li>
  <li><a href="#cluster-message">Cluster message</a></li>
  <li><a href="#configuration">Configuration</a></li>
  <li><a href="#logging">Logging</a></li>
  <li><a href="#beanPersistListener">BeanPersistListener</a></li>
  <li><a href="#external-modification">External modification</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${monitoring!''}" url="/docs/features/monitoring" title="Monitoring"/>
<@smallnav activeCheck="${dbmigration!''}" url="/docs/setup/dbmigration" title="DB Migration">
</@smallnav>