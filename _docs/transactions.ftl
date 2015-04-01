<div class="bs-docs-section">
<h1 id="transactions">Transactions</h1>


<p>Within a Transaction, you can also control JDBC batching (batch size, flushing), turn on/off
transaction logging, and turn on/off cascading of save and delete. ...(under construction)... how?</p>


<#-------------------------------------------------------------------------------------------------->
<h2 id="implicit_transactions">Implicit</h2>
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

<h2 id="tx_control_behaviour">Controlling behaviour in a transaction</h2>
<p>
You can use the Transaction to explicitly control behaviour.

```java
Transaction transaction = ebeanServer.beginTransaction();
try {
  // turn of cascade persist
  transaction.setCascadePersist(false);

  // control the jdbc batch mode and size
  // transaction.setBatchMode(true); // equivalent to transaction.setBatch(PersistBatch.ALL);
  // transaction.setBatchMode(false); // equivalent to transaction.setBatch(PersistBatch.NONE);
  transaction.setBatch(PersistBatch.ALL); // PersistBatch: NONE, INSERT, ALL
  transaction.setCascadeBatch(PersistBatch.INSERT); // PersistBatch: NONE, INSERT, ALL
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
</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="transactional">@Transactional</h2>
<p>
You must be using <em>ENHANCEMENT</em> for @Transactional to work. That means you
must be enhancing the classes via IDE Plugin, Ant Task or javaagent. Refer to the
user guide for more details on enhancement.
</p>

<p>
Ebean can enhance your pojos to add transactional support. To do so put the
@Transaction annotation on a method or class. Ebean enhancement will then add
the supporting transactional logic (begin transaction, commit, rollback, suspend and resuming transactions etc).
</p>

```java
...
// any old pojo
public class MyService {

	@Transactional
	public void runFirst() throws IOException {

		// run in a Transaction (REQUIRED is the default)

		// find a customer
		Customer customer = Ebean.find(Customer.class, 1);

		// call another "transactional" method
		runInTrans();
	}

	@Transactional(type=TxType.REQUIRES_NEW)
	public void runInTrans() throws IOException {

		// run in its own NEW transaction
		// ... suspend an existing transaction if required
		// ... and resume it when this method ends

		// find new orders
		List&lt;Order&gt; orders = Ebean.find(Order.class)
									.where().eq("status",OrderStatus.NEW)
									.findList();
		...
```

<p>
Put the @Transactional annotation on you methods and Ebean
can enhance the classes adding the Transactional management.
</p>

<h4 class="plain">Standard transaction scope types</h4>
<p>
This supports the standard propagation rules of
REQUIRED (the default), REQUIRES_NEW, MANDATORY, SUPPORTS, NOT_SUPPORTS, NEVER.
These are an exact match of the EJB TransactionAttributeTypes.
</p>

<h4 class="plain">Nested Transactions</h4>
<p>
Transactional methods can be nested as in the above example where
runFirst() calls runInTrans().
</p>

<h4 class="plain">Isolation level and specific exception support</h4>
<p>
@Transactional (like Spring) supports isolation levels and explicit
handling of Exceptions (to rollback or not for specific exceptions).
Please refer to the User Guide for a more detailed explanation.
</p>

<h4 class="plain">Interfaces</h4>
<p>
You can put @Transactional on interfaces and classes that
implement those interfaces will get the transactional enhancement.
</p>


<#-------------------------------------------------------------------------------------------------->
<h2 id="tx_runnable">TxRunnable / TxCallable</h2>
<p>
TxRunnable and TxCallable are the programmatic equivalent to @Transactional.
</p>
<p>
You can mix @Transaction with TxRunnable and TxCallable if you like, they
will behave correctly together.
</p>

```java
public void myMethod() {
  ...
  System.out.println(" Some code in myMethod...");

  // run in Transactional scope...
  Ebean.execute(new TxRunnable() {
	public void run() {

		// code running in "REQUIRED" transactional scope
		// ... as "REQUIRED" is the default TxType
		System.out.println(Ebean.currentTransaction());

		// find stuff...
		User user = Ebean.find(User.class, 1);
		...

		// save and delete stuff...
		Ebean.save(user);
		Ebean.delete(order);
		...
	}
  });

  System.out.println(" more code in myMethod...");
}
```
<p>
Generally you will use TxRunnable like the above as anonymous inner classes.
</p>
<p>
The code inside the run() will execute inside a transactional scope with Ebean
handling the transaction propagation for you (just like @Transactional).
</p>

```java
// programmatic control over the scope such as
// ... isolation level
// ... and to rollback or not for specific exceptions

TxScope txScope = TxScope
			.requiresNew()
			.setIsolation(TxIsolation.SERIALIZABLE)
			.setNoRollbackFor(IOException.class);

Ebean.execute(txScope, new TxRunnable() {
	public void run() {
		...
}
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="Spring">Spring</h2>
(under construction)

<#-------------------------------------------------------------------------------------------------->
<h2 id="jta">JTA</h2>
(under construction)

</div>
