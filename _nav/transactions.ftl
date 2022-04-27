<ul class="nav">
  <@nav1 activeCheck="${n2_transactions!''}" url="/docs/transactions/" title="Introduction">
    <ul class="nav nav-scroll">
      <li><a href="#transactional">@Transactional</a></li>
      <li><a href="#current">Transaction.current()</a></li>
      <li><a href="#beginTransaction">beginTransaction()</a></li>
      <li><a href="#end">commit(), rollback(), end()</a></li>
      <li><a href="#commitAndContinue">commitAndContinue()</a></li>
      <li><a href="#setRollbackOnly">setRollbackOnly()</a></li>
      <li><a href="#createTransaction">createTransaction()</a></li>
      <li><a href="#implicit">Implicit transactions</a></li>
    </ul>
  </@nav1>

  <@nav1 activeCheck="${n2_batch!''}" url="/docs/transactions/batch" title="Batch">
    <ul class="nav nav-scroll">
      <li><a href="#transactionalBatchSize">@Transactional(batchSize)</a></li>
      <li><a href="#batchSize">Batch size</a></li>
      <li><a href="#generatedKeys">GetGeneratedKeys()</a></li>
      <li><a href="#flush">Flush</a></li>
      <li><a href="#flushOnQuery">setBatchFlushOnQuery()</a></li>
      <li><a href="#flushOnMixed">setBatchFlushOnMixed()</a></li>
      <li><a href="#flushOnGetter">Flush on getter/setter</a></li>
      <li><a href="#flushExplicit">Explicit flush()</a></li>
      <li><a href="#serverConfig">Configuration via ServerConfig</a></li>
    </ul>
  </@nav1>

  <@nav1 activeCheck="${n2_scopes!''}" url="/docs/transactions/scopes" title="Scopes"/>
  <@nav1 activeCheck="${n2_savepoints!''}" url="/docs/transactions/savepoints" title="Savepoints"/>
  <@nav1 activeCheck="${n2_spring!''}" url="/docs/transactions/spring" title="Spring"/>
  <@nav1 activeCheck="${n2_jta!''}" url="/docs/transactions/jta" title="JTA"/>
</ul>
