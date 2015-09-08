<@smallnav activeCheck="${introduction!''}" url="/docs/introduction" title="Introduction">
<ul class="nav">
  <li><a href="#use_jpa_mapping">Use JPA mappings</a></li>
  <li><a href="#simple_query_language">Simple query language</a></li>
  <li><a href="#intro_save_and_delete">Save and delete</a></li>
  <li><a href="#jpa_comparison">Comparison to JPA</a></li>
  <li><a href="#ebean_does_not">Ebean does not...</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${enhancement!''}" url="/docs/enhancement" title="Enhancement">

<ul class="nav">
  <li><a href="#enhance_maven">Maven</a></li>
  <li><a href="#enhance_maven_eclipse">Eclipse + Maven</a></li>
  <li><a href="#enhance_ant">Ant</a></li>
  <li><a href="#enhance_agent">Agent</a></li>
  <li><a href="#enhance_ide">IDE enhancement</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${serverconfig!''}" url="/docs/serverconfig" title="ServerConfig">
<ul class="nav">
  <li><a href="#ebean-properties">ebean.properties</a></li>
  <li><a href="#external-properties">External properties</a></li>
  <li><a href="#server">Register</a></li>
  <li><a href="#default">Default server</a></li>
  <li><a href="#di">Dependency injection</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${guice!''}" url="/docs/guice" title="Guice">
<ul class="nav">
  <li><a href="#provider">Provider</a></li>
  <li><a href="#module">Module bind</a></li>
  <li><a href="#activerecord">Inject and ActiveRecord</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${spring!''}" url="/docs/spring" title="Spring">
<ul class="nav">
  <li><a href="#active-record">avaje-ebeanorm-spring</a></li>
  <li><a href="#factory">FactoryBean</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${activerecord!''}" url="/docs/activerecord" title="Active Record">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#criticism">Criticism</a></li>
  <li><a href="#jpa">JPA and active record</a></li>
  <li><a href="#ebean">Ebean and active record</a></li>
  <li><a href="#testing">Testing</a></li>
  <li><a href="#benefits">Benefits</a></li>
  <li><a href="#model">Model</a></li>
  <li><a href="#finder">Finder</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${testing!''}" url="/docs/testing" title="Testing">
<ul class="nav">
  <li><a href="#mockibean">MockiEbean</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${queries!''}" url="/docs/queries" title="Queries">
<ul class="nav">
  <li><a href="#where_clause">Where clause</a></li>
  <li><a href="#query_language">Ebean query language</a></li>
  <li><a href="#partial_objects">Partial objects</a></li>
  <li><a href="#query_joins">Query joins</a></li>
  <li><a href="#fetchconfig">FetchConfig</a></li>
  <li><a href="#lazy_loading">Lazy loading</a></li>
  <li><a href="#named_queries">Named Queries</a></li>
  <li><a href="#large_queries">Large queries</a></li>
  <li><a href="#paging">Paging</a></li>
  <li><a href="#async_queriess">Asynchronous queries</a></li>
  <li><a href="#rawsql">RawSql</a></li>
  <li><a href="#sqlquery">SqlQuery</a></li>
  <li><a href="#l2cache">L2 cache</a></li>
  <li><a href="#autofetch">Autofetch</a></li>
  <li><a href="#other_bits">Other bits</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${saving!''}" url="/docs/saving" title="Saving">
<ul class="nav">
  <li><a href="#saves">Save</a></li>
  <li><a href="#deletes">Delete</a></li>
  <li><a href="#cascading">Cascade</a></li>
  <li><a href="#bulkupdate">Bulk updates</a></li>
  <li><a href="#bulksqlupdate">Bulk SQL updates</a></li>
  <li><a href="#callablesql">CallableSql</a></li>
  <li><a href="#rawjdbc">Raw JDBC</a></li>
  <li><a href="#batch_processing">JDBC Batch</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${mapping!''}" url="/docs/mapping" title="Mapping">
<ul class="nav">
  <li><a href="#jpa_mapping">JPA mapping</a></li>
  <li><a href="#ddl_generation">DDL generation</a></li>
  <li><a href="#naming_convention">Naming convention</a></li>
  <li><a href="#mapping_annotations">Mapping annotations</a></li>
  <li><a href="#relationships">Relationships</a></li>
  <li><a href="#id_generation">Id generation</a></li>
  <li><a href="#formula">Formula</a></li>
  <li><a href="#enummapping">EnumMapping</a></li>
  <li><a href="#encryption">Encryption</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${transactions!''}" url="/docs/transactions" title="Transactions">
<ul class="nav">
  <li><a href="#implicit_transactions">Implicit</a></li>
  <li><a href="#programmatic_transactions">Programmatic</a></li>
  <li><a href="#tx_control_behaviour">Controlling behaviour in a transaction</a></li>
  <li><a href="#transactional">@Transactional</a></li>
  <li><a href="#tx_runnable">TxRunnable / TxCallable</a></li>
  <li><a href="#spring">Spring</a></li>
  <li><a href="#jta">JTA</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${json!''}" url="/docs/json" title="JSON"/>
<@smallnav activeCheck="${eventlisteners!''}" url="/docs/eventlisteners" title="Event listeners"/>
<@smallnav activeCheck="${readaudit!''}" url="/docs/readaudit" title="Read Audit"/>
<@smallnav activeCheck="${changelog!''}" url="/docs/changelog" title="Change Log"/>
<@smallnav activeCheck="${history!''}" url="/docs/history" title="History">
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
<@smallnav activeCheck="${l2caching!''}" url="/docs/l2caching" title="L2 caching">
<ul class="nav">
  <li><a href="#bean_and_query_caches">Bean and query caches</a></li>
  <li><a href="#read_only_instances">Read only instances</a></li>
  <li><a href="#shared_instances">Shared instances</a></li>
  <li><a href="#automatic_cache_maint">Automatic Cache Maintenance</a></li>
  <li><a href="#external_mods">Handling External Modification</a></li>
  <li><a href="#cachestrategy">@CacheStrategy</a></li>
  <li><a href="#manual_cache_use">Manually specifying to use the bean cache</a></li>
  <li><a href="#using_query_cache">Using the Query Cache</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${jvmlanguages!''}" url="/docs/jvmlanguages" title="JVM Languages">
<ul class="nav">
  <li><a href="#groovy">Groovy</a></li>
  <li><a href="#scala">Scala</a></li>
</ul>
</@smallnav>

<@smallnav activeCheck="${clustering!''}" url="/docs/clustering" title="Clustering"/>
<@smallnav activeCheck="${monitoring!''}" url="/docs/monitoring" title="Monitoring"/>
<@smallnav activeCheck="${architecture!''}" url="/docs/architecture" title="Architecture">
<ul class="nav">
  <li><a href="#persistence_context">Persistence context</a></li>
  <li><a href="#internals">Internals</a></li>
</ul>
</@smallnav>
