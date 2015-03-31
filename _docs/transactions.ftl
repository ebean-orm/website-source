<div class="bs-docs-section">
<h1 id="transactions">Transactions</h1>

<#-------------------------------------------------------------------------------------------------->
<h2 class="implicit_transactions">Implicit</h2>
<h4>Transactions are created implicitly for you</h4>

<p>
When there is no current transaction you can still execute a query, save or delete a bean etc.
When this happens Ebean will create an implicit transaction and commit it (or rollback if there was a failure).
</p>

```java

// execute a query without an existing transaction...
// ... a "implicit" transaction will be created
// ... and be commited (or rolled back) for you
List<User> users =
            Ebean.find(User.class)
                .join("customer")
                .where().eq("state", UserState.ACTIVE)
                .findList();

// execute a save without an existing transaction...
// ... will create an implicit transaction
// ... and be commited (or rolled back) for you
Ebean.save(user);

```

<p>
The following SLF4J logs show the transaction that was implicitly created for the query.
</p>
```java

16:38:26.362 [main] DEBUG c.a.e.server.lib.thread.ThreadPool - ThreadPool grow created [Ebean-h2.0] size[0]
16:38:26.369 [main] TRACE org.avaje.ebean.TXN - txn[1002] Begin
16:38:26.548 [main] INFO  org.avaje.ebean.TXN - txn[1002] Commit
16:38:26.551 [main] TRACE org.avaje.ebean.TXN - txn[1003] Begin
16:38:26.554 [main] TRACE org.avaje.ebean.SQL - txn[1003] delete from or_order_ship
16:38:26.555 [main] DEBUG org.avaje.ebean.SUM - txn[1003] Delete table[or_order_ship] rows[0] bind[null]
16:38:26.556 [main] TRACE org.avaje.ebean.SQL - txn[1003] delete from o_order_detail
16:38:26.557 [main] DEBUG org.avaje.ebean.SUM - txn[1003] Delete table[o_order_detail] rows[0] bind[null]
16:38:26.557 [main] TRACE org.avaje.ebean.SQL - txn[1003] delete from o_order
16:38:26.557 [main] DEBUG org.avaje.ebean.SUM - txn[1003] Delete table[o_order] rows[0] bind[null]
16:38:26.557 [main] TRACE org.avaje.ebean.SQL - txn[1003] delete from contact
16:38:26.557 [main] DEBUG org.avaje.ebean.SUM - txn[1003] Delete table[contact] rows[0] bind[null]
16:38:26.557 [main] TRACE org.avaje.ebean.SQL - txn[1003] delete from o_customer
16:38:26.557 [main] DEBUG org.avaje.ebean.SUM - txn[1003] Delete table[o_customer] rows[0] bind[null]
16:38:26.557 [main] TRACE org.avaje.ebean.SQL - txn[1003] delete from o_address
16:38:26.558 [main] DEBUG org.avaje.ebean.SUM - txn[1003] Delete table[o_address] rows[0] bind[null]
16:38:26.563 [main] TRACE org.avaje.ebean.SQL - txn[1003] delete from o_country
16:38:26.563 [main] DEBUG org.avaje.ebean.SUM - txn[1003] DeleteSql table[o_country] rows[0] bind[null]
16:38:26.563 [main] TRACE org.avaje.ebean.SQL - txn[1003] delete from o_product
16:38:26.564 [main] DEBUG org.avaje.ebean.SUM - txn[1003] DeleteSql table[o_product] rows[0] bind[null]
16:38:26.567 [main] TRACE org.avaje.ebean.SQL - txn[1003] insert into o_country (code, name) values (?,?); --bind(NZ,New Zealand,)
16:38:26.568 [main] DEBUG org.avaje.ebean.SUM - txn[1003] Inserted [Country] [NZ]
16:38:26.568 [main] TRACE org.avaje.ebean.SQL - txn[1003] insert into o_country (code, name) values (?,?); --bind(AU,Australia,)
16:38:26.568 [main] DEBUG org.avaje.ebean.SUM - txn[1003] Inserted [Country] [AU]
16:38:26.570 [main] TRACE org.avaje.ebean.SQL - txn[1003] insert into o_product (id, sku, name, cretime, updtime) values (?,?,?,?,?); --bind

```

<#-------------------------------------------------------------------------------------------------->
<h2 id="programmatic_transactions">Programmatic</h2>
<h4>Using begin, commit etc in a try finally block</h4>
<p>
A traditional approach for demarcating transactions via a try finally block.
</p>

```java


ebeanServer.beginTransaction();
try {
  // fetch some stuff...
  Customer customer = ebeanServer.find(Customer.class, id);
  ...

  // save or delete stuff...
  ebeanServer.save(customer);
  ...

  // commit the transaction
  ebeanServer.commitTransaction();

} finally {
  // rollback the transaction if it was not committed
  ebeanServer.endTransaction();
}

```

<h2>Use the Transaction</h2>
<p>
You can use the Transaction to explicitly control behaviour.
</p>


```java


Transaction transaction = ebeanServer.beginTransaction();
try {
  // turn of cascade persist
  transaction.setCascadePersist(false);

  // control the jdbc batch mode and size
  transaction.setBatchMode(true);
  transaction.setBatchSize(30);

  // for a large batch insert if you want to skip
  // getting the generated keys
  transaction.setBatchGetGeneratedKeys(false);

  // for batch processing via raw SQL you can inform
  // Ebean what tables were modified so that it can
  // clear the appropriate L2 caches
  String tableName = "o_customer";
  boolean inserts = true;
  boolean upates = true;
  boolean deletes = false;
  transaction.addModification(tableName, inserts, updates, deletes);

  ...
} finally {
  transaction.end();
}

```

<#-------------------------------------------------------------------------------------------------->
<h2 id="transactional">@Transactional</h2>
...

<#-------------------------------------------------------------------------------------------------->
<h2 id="tx_runnable">TxRunnable / TxCallable</h2>
...

<#-------------------------------------------------------------------------------------------------->
<h2 id="Spring">Spring</h2>
...

<#-------------------------------------------------------------------------------------------------->
<h2 id="jta">JTA</h2>
...


</div>
