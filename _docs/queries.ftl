<div class="bs-docs-section">
<h1 id="queries">Queries</h1>

```java

// find an order by its id
Order order = Ebean.find(Order.class, 12);

```

```sql
select o.id, o.order_date, o.ship_date, o.cretime, o.updtime, o.status_code, o.customer_id
from or_order o
where o.status_code = ? and o.ship_date > ?

```

<#-------------------------------------------------------------------------------------------------->
<h2 id="where_clause">Where clause</h2>
<h4>
Specifying 'predicates' for the where clause.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->

<h2 id="partial_objects">Partial objects</h2>
  <p>
      The Query object has select() and fetch() methods and these allow you to specify
      the properties that should be fetched.
  </p>
  <h4>Select</h4>
  <p>
      With select you specify the properties that should be fetched on the root level type.
  </p>
  <h4>Fetch</h4>
  <p>
      With fetch you specify the properties that should be fetched on the associated beans.
  </p>

  <h4>Select example</h4>
  <p>
  Partially loading a bean or object graph using select() and fetch().
  </p>
```java
  Customer customer = Customer.find
    .select("name")
    .where().idEq(1L)
    .findUnique();
```

```sql
select t0.id c0, t0.name c1
  from o_customer t0
 where t0.id = ?  ; --bind(1)
```

<h4>Select and fetch example</h4>
```java
  Order order = Order.find
    .select("status, orderDate, shipDate")
    .fetch("customer", "name")
    .fetch("details")
    .fetch("details.product", "sku")
    .where().idEq(1L)
    .findUnique();
```
```sql

  select t0.id c0, t0.status c1, t0.order_date c2, t0.ship_date c3,
         t1.id c4, t1.name c5, -- customer name
         t2.id c6, t2.order_qty c7, t2.ship_qty c8, t2.unit_price c9, t2.version c10,
         t2.when_created c11, t2.when_updated c12, t2.order_id c13,
         t3.id c14, t3.sku c15 -- product sku
  from o_order t0
  join o_customer t1 on t1.id = t0.customer_id
  left outer join o_order_detail t2 on t2.order_id = t0.id
  left outer join o_product t3 on t3.id = t2.product_id
  where t0.id = ?
  order by t0.id, t2.id asc; --bind(1)
```

<#-------------------------------------------------------------------------------------------------->

<h2 id="query_joins">Query joins</h2>
<h4>
    Controlling eager loading of the object graph using query joins.
</h4>
<p>
  When more than 1 OneToMany or ManyToMany relationship is eagerly fetched
    then Ebean will automatically convert one of those into a 'Query Join'. Ebean does this so that it avoids
    generating a cartesian product query.
</p>
<h4>Example 1</h4>
<p>
    It this example both "customer.contacts" and "details" are OneToMany relationships.
</p>
```java
List<Order> orders = Order.find
    .select("status")
    .fetch("customer")
    .fetch("customer.contacts")       // contacts is a @OneToMany
    .fetch("details")                 // details is a @OneToMany
    .orderBy("customer.name")
    .findList();
```

```sql
-- This first query includes the customer contacts
-- but does not include the order details
select t0.id c0, t0.status c1,
       t1.id c2, t1.inactive c3, t1.name c4, ...           -- truncated
       t2.id c12, t2.first_name c13, t2.last_name c14, ... -- truncated
       t2.when_updated c19, t2.customer_id c20
 from o_order t0
 join o_customer t1 on t1.id = t0.customer_id
 left outer join o_contact t2 on t2.customer_id = t1.id
order by t1.name;
```

<h4>The 'Query Join' query ...</h4>
```sql
-- This second query fetchs the order details associated
-- with the orders that were returned by the first query
select t0.order_id c0, t0.id c1, t0.order_qty c2, ...
  from o_order_detail t0
 where (t0.order_id) in (?,?,?,?,?,?,?,?,?,?)
 order by t0.order_id, t0.id;
--bind(2,1,1,1,3,3,3,4,4,4)
```

<h4>Example 2</h4>
    <p>
        In this example contacts is a @OneToMany and then off from each contact notes is a @OneToMany.
    </p>
```java
List<Customer> customers = Customer.find
    .fetch("contacts")              // contacts is a OneToMany
    .fetch("contacts.notes")        // notes is a OneToMany
    .orderBy("name")
    .findList();
```

```sql
select t0.id c0, t0.inactive c1, t0.name c2, ...
       t0.when_updated c7, t0.billing_address_id c8, ...
       t1.id c10, t1.first_name c11, t1.last_name c12, ...
from o_customer t0
left outer join be_contact t1 on t1.customer_id = t0.id
order by t0.name, t0.id
```

<h4>The 'Query Join' query ...</h4>
```sql
-- fetch the contact notes for all the contacts
select t0.contact_id c0, t0.id c1, t0.contact_id c2, t0.title c3, ...
  from contact_note t0
 where (t0.contact_id) in (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="loading">Loading</h2>
<h4>
Controlling how an object graph loads with query joins and lazy loading.
</h4>
...(to be filled in)...


<#-------------------------------------------------------------------------------------------------->
<h2 id="lazy_loading">Lazy loading</h2>
<h4>
Fine grained control over lazy loading.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="large_queries">Large queries</h2>
<h4>
Processing large query results using findIterate() and findVisit().
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="row_count">Row count</h2>
<h4>
Fetching the 'row count'.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="paging">Paging</h2>
<h4>
Using firstRows and maxRows or findPagedList to fetch a 'page' of results.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="find_ids">Find Ids</h2>
<h4>
When you just want to fetch the Id's.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="rawsql">RawSql</h2>
<h4>
Using RawSql to fully control the SQL used to load an object graph.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="sqlquery">SqlQuery</h2>
<h4>
Performing sql queries returning relational SqlRow's rather than beans / object graphs.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="l2cache">L2 Cache</h2>
<h4>
How to use the L2 cache with queries.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="autofetch">Autofetch</h2>
<h4>
Let Ebean automatically tune you queries using Autofetch.
</h4>
...(to be filled in)...

<#-------------------------------------------------------------------------------------------------->
<h2 id="other_bits">Other Bits</h2>
<h4>
Other features for controlling queries.
</h4>
<ul>
  <li>forUpdate</li>
  <li>filterMany</li>
  <li>bufferFetchSize</li>
  <li>timeout</li>
  <li>distinct</li>
</ul>
...(to be filled in)...

</div>
