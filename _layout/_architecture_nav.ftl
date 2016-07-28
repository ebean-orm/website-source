<@smallnav activeCheck="${compareJPA!''}" url="/architecture/compare-jpa" title="JPA comparison">
<ul class="nav">
  <li><a href="#sessionless">Sessionless architecture</a></li>
  <li><a href="#persist-features">Persist features</a></li>
  <li><a href="#query-features">Query features</a></li>
  <li><a href="#mapping">Mapping</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${compareHibernate!''}" url="/architecture/compare-hibernate" title="Hibernate comparison">
<ul class="nav">
  <li><a href="#max-rows">Honoring maxRows in SQL</a></li>
  <li><a href="#cartesian-product">SQL cartesian product</a></li>
  <li><a href="#lazy-initialization-exception">LazyInitializationException</a></li>
  <li><a href="#open-session-in-view">Open session in view</a></li>

  <li><a href="#history">@History vs Envers</a></li>
  <li><a href="#optimising-fetch">Optimising fetch</a></li>
  <li><a href="#paged-list">PagedList / findRowCount</a></li>
  <li><a href="#find-each">findEach vs Scroll</a></li>
  <li><a href="#set-list">Set vs List</a></li>
  <li><a href="#mapping">Mapping</a></li>
</ul>
</@smallnav>
<@smallnav activeCheck="${persistenceContext!''}" url="/architecture/persistence-context" title="Persistence context">
<ul class="nav">
  <li><a href="#definition">Definition</a></li>
  <li><a href="#unique-instances">Unique entity instances</a></li>
  <li><a href="#persisting">Persisting</a></li>
  <li><a href="#scopes">Scopes</a></li>
  <li><a href="#transaction-scope">Transaction scope</a></li>
  <li><a href="#query-scope">Query scope</a></li>
  <li><a href="#object-scope">Object graph scope</a></li>
</ul>
</@smallnav>

<@smallnav activeCheck="${loadContext!''}" url="/architecture/load-context" title="Load context">
<ul class="nav">
  <li><a href="#overview">Overview</a></li>
  <li><a href="#batch">Batch loading</a></li>
  <li><a href="#propagate">Propagate query context</a></li>
</ul>
</@smallnav>



