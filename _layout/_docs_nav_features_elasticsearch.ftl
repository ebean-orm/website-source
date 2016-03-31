
<@smallnav activeCheck="${elastic_overview!''}" url="/docs/features/elasticsearch" title="Overview">
<ul class="nav">
  <li><a href="#why">Why integrate</a></li>
  <li><a href="#graphs-as-json">ORM graphs as JSON</a></li>
  <li><a href="#automatic-sync">Automatic Sync</a></li>
  <li><a href="#query">Query</a></li>
  <li><a href="#query-full-text">Query - full text</a></li>
  <li><a href="#out-of-scope">Currently out of scope</a></li>

</ul>
</@smallnav>
<@smallnav activeCheck="${elastic_mapping!''}" url="/docs/features/elasticsearch/mapping" title="Mapping">
<ul class="nav">
  <li><a href="#Overview">Overview</a></li>
  <li><a href="#DocStore">@DocStore</a></li>
  <li><a href="#DocEmbedded">@DocEmbedded</a></li>
  <li><a href="#DocCode">@DocCode</a></li>
  <li><a href="#DocSortable">@DocSortable</a></li>
  <li><a href="#DocProperty">@DocProperty</a></li>
  <li><a href="#mapping-generation">Mapping generation</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${elastic_indexes!''}" url="/docs/features/elasticsearch/indexes" title="Indexes">
<ul class="nav">
  <li><a href="#aliases">Aliases</a></li>
  <li><a href="#createIndex">Create index</a></li>
  <li><a href="#dropIndex">Drop index</a></li>
  <li><a href="#copyIndex">Copy index</a></li>
  <li><a href="#indexAll">Index all</a></li>
  <li><a href="#indexByQuery">Index by query</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${elastic_query!''}" url="/docs/features/elasticsearch/query" title="Query">
<ul class="nav">
  <li><a href="#order-by">orderBy -> sort</a></li>
  <li><a href="#max-rows">firstRows/maxRows -> from/size</a></li>
  <li><a href="#select">select/fetch -> fields/include</a></li>
  <li><a href="#filter-context">where -> filter context</a></li>
  <li><a href="#query-context">text -> query context</a></li>
  <li><a href="#use-doc-store">Explicit useDocStore(true)</a></li>
  <li><a href="#implied-use-doc-store">Implied useDocStore(true)</a></li>
  <li><a href="#must-must-not-should">Must, must not, should</a></li>

</ul>
</@smallnav>
<@smallnav activeCheck="${elastic_syncing!''}" url="/docs/features/elasticsearch/syncing" title="Syncing">
<ul class="nav">
  <li><a href="#post-commit">Post commit</a></li>
  <li><a href="#transaction-ignore">Transaction mode ignore</a></li>
  <li><a href="#insert">Insert</a></li>
  <li><a href="#delete">Delete</a></li>
  <li><a href="#update">Update</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${elastic_start!''}" url="/docs/features/elasticsearch/get-started" title="Getting started">
<ul class="nav">
  <li><a href="#example-application">Example application</a></li>
  <li><a href="#dependencies">Dependencies</a></li>
  <li><a href="#bean-mapping">Bean mapping</a></li>
  <li><a href="#generate-mapping">Generating mapping</a></li>
  <li><a href="#issues">Review issues</a></li>
</ul>
</@smallnav>