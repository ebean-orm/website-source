<div class="bs-docs-section">
<h1 id="updates">Updates</h1>


<#-------------------------------------------------------------------------------------------------->
<h2 id="saves">Saves</h2>
<p>
Save will either insert or update the bean depending on its state.
</p>
```java
Order order = new Order();
order.setOrderDate(new Date());
...
// insert the order
Ebean.save(order);
```
<p>
If the bean was fetched it will be updated...
</p>

```
Order order = Ebean.find(Order.class, 12);
order.setStatus("SHIPPED");
...
// update the order
Ebean.save(order);
```
<p>
Save and Delete will CASCADE based on the CascadeType
specificed on the associated @OneToMany, @OneToOne etc annotation.
</p>
<p>
By default save and delete will not cascade so you need to
specify a cascade type (such as the one on details below) for
save() or delete() to cascade.
</p>

```
...
// the Entity bean with its Mapping Annotations
...
@Entity
@Table(name="or_order")
public class Order {

    ...
	// no cascading
    @ManyToOne
    Customer customer;

	// save and delete cascaded
    @OneToMany(cascade=CascadeType.ALL)
    List&lt;OrderDetail&gt; details;

	...
```

<p>
Note the <em>@OneToMany(cascade=CascadeType.ALL)</em> on
the details property. This means save() and delete() will
both casade from order to its order details.
</p>

```
...
// save the order ...  will cascade also saving the order details
Ebean.save(order);
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="deletes">Deletes</h2>
<p>
Delete is very similar to save. Just call Ebean.delete();
</p>

```
...
Order order = Ebean.find(Order.class, 12);

// delete the order
// ... this will cascade also deleting the order details
// ... with either CascadeType.ALL or CascadeType.REMOVE
Ebean.delete(order);
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="cascading">Cascading</h2>
<p>The mapping annotations @ManyToOne, @OneToMany, @OneToOne and
@ManyToMany provide a cascade attribute which is used to control whether saves and
deletes are cascaded.</p>

<p>The default is to not cascade a save or delete (as per JPA spec).</p>


<p>The example below shows the Order entity bean with its mapping annotations. If you save
an Order the details will be saved as well but the associated customer will not be saved as
there is no cascade atttribute and the default is to not cascade.</p>

```java
...
@Entity
@Table(name="or_order")
public class Order {
  ...
  // no cascading
  @ManyToOne
  Customer customer;

  // save and delete cascaded
  @OneToMany(cascade=CascadeType.ALL)
  List<OrderDetail> details;
```

<h2 id="bulkupdate">Bulk updates</h2>
<p>Update provides a way on issuing a insert, update or delete statement.</p>
<p>
This is useful for updating or deleting multiple rows (or a single row) with a single
statement (often described as a "bulk" update).</p>
<p>This is also useful if you want to perform an update or delete without having to execute a
query first. This is a typical approach for performing an update in a stateless web
application.</p>
<p>The statement can be provided in as raw DML with the table names and column names or
in a 'logical' form where entity name is used in place of the table name and property
names are used in place of column names.</p>

```java
// orm bulk delete use bean name and bean properties
server.createUpdate(OrderDetail.class, "delete from orderDetail").execute();

// sql bulk update uses table and column names
server.createSqlUpdate("delete from o_country").execute();
````

<h2 id="bulksqlupdate">Bulk SQL updates</h2>

<p>In similar fashion to <a href="#sqlquery">SqlQuery</a> you can specify a SQL INSERT, UPDATE or DELETE statement with named or positioned parameters.</p>

```java
String dml = "update b_bug set title=:title where id = :id";
SqlUpdate update = Ebean.createSqlUpdate(dml)
  .setParameter("title", "Updated Again")
  .setParameter("id", 1);
int rows = update.execute();
```

<h2 id="callablesql">CallableSql</h2>

<p>CallableSql provides a way to call a database stored procedure.</p>

```java
String sql = "{call sp_order_mod(?,?)}";
CallableSql cs = Ebean.createCallableSql(sql);
cs.setParameter(1, "turbo");
cs.registerOut(2, Types.INTEGER);
Ebean.execute(cs);

// read the out parameter
Integer returnValue = (Integer) cs.getObject(2);
```

<p>You can extend CallableSql and you can also get the java.sql.Connection from a Transaction and use raw JDBC API to call a stored procedure.</p>


<h2 id="rawjdbc">Raw JDBC</h2>

<p>You can't always predict when your application requirements can't be meet with the
features in Ebean. It is nice you now you can easily use raw JDBC if and when you need
to.</p>
<p>The java.sql.Connection object can be returned from a transaction, and with that you can
perform any raw JDBC calls you like.</p>

<p>This may be useful for Savepoints, advanced Clob/Blob use or advanced stored
procedure calls (if CallableSql doesn't do the business for you).</p>

```java
Transaction transaction = Ebean.beginTransaction();
try {
  Connection connection = transaction.getConnection();
  // use raw JDBC
  ...
  // assuming we updated the "o_shipping_details" table
  // inform Ebean so it can maintain it's 'L2' cache
  transaction.addModification("o_shipping_details",false,true,false);
  Ebean.commitTransaction();
} finally {
  Ebean.endTransaction();
}
```

<p>The <b>transaction.addModification()</b> in the code above informs Ebean that your jdbc code
updated the o_shipping_details table. Ebean uses this information to automatically
manage its "L2" cache as well as maintain Lucene text indexes.</p>

<h2 id="batch_processing">Batch processing</h2>
<p>
  Ebean provides support for JDBC batch processing.  Batch processing groups related SQL statements into a batch and submits them with one call to the database.
</p>
<p>
  Batch settings can be configured through <a href="properties_config">ebean.properties</a> or through <a href="programmatic_config">ServerConfig</a>, and can be overridden per transaction.
</p>

<p>
  You can set the batch mode for the entity being saved through setBatch() and for its child collections through setCascadeBatch().
</p>

<p>
  ...(under construction)... need to provide better guidance on how to determine batch mode, child batch mode, and batch size
</p>

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

example using @Transactional
```java
@Transactional(batch = PersistBatch.ALL, batchOnCascade = PersistBatch.ALL, batchSize = 99)
  public void doWithBatchOptionsSet() {

    Transaction txn = Ebean.currentTransaction();
    assertEquals(PersistBatch.ALL, txn.getBatch());
    assertEquals(PersistBatch.ALL, txn.getBatchOnCascade());
    assertEquals(99, txn.getBatchSize());
}
```

</div>
