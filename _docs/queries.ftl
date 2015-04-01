<div class="bs-docs-section">
<h1 id="queries">Queries</h1>

```java
// find by id
Order order = Ebean.find(Order.class, 12);
```
executes the sql:
```sql
select o.id, o.order_date, o.ship_date, o.cretime, o.updtime, o.status_code, o.customer_id
from or_order o
where or.id = ?
```

```java
// these are the same
Query<Order> query = Ebean.createQuery(Order.class);
Query<Order> query = Ebean.find(Order.class);
```
These two methods do exactly the same thing. The reason both
exist is because the createQuery() style is consistent with JPA and could be argued is a
better more accurate name. And find() is more consistent with the fluid API style.

```java
// fluid API style with find()
List<Order> list =
Ebean.find(Order.class)
  .fetch("customer")
  .where().eq("status.code", "SHIPPED")
  .findList();
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="where_clause">Where clause</h2>
<p>
You can specify 'predicates' for the where clause.
</p>

```java
// find all the orders shipped since a week ago
List<Order> list = Ebean.find(Order.class)
    .where()
      .eq("status", Order.Status.SHIPPED)
      .gt("shipDate", lastWeek)
    .findList();
```

<h4>Example Predicates</h4>
<ul>
  <li>eq(...) = equals</li>
  <li>ne(...) = not equals<li>
  <li>ieq(...) = case insensitve equals</li>
  <li>between(...) = between</li>
  <li>gt(...) = greater than</li>
  <li>ge(...) = greater than or equals</li>
  <li>lt(...) = less than or equals</li>
  <li>le(...) = less than or equals</li>
  <li>isNull(...) = is null</li>
  <li>isNotNull(...) = is not null</li>
  <li>like(...) = like</li>
  <li>startsWith(...) = string starts with</li>
  <li>endswith(...) = string ends with</li>
  <li>contains(...) = string conains </li>
  <li>in(...) = in a subquery, collection or array</li>
  <li>exists(...) = at least one row exists in a subquery</li>
  <li>notExists(...) = no row exists in a subquery</li>
  <li>more...</li>
</ul>
<p>
Use code completion in your favorite ide or see <a href="/apidocs/com/avaje/ebean/ExpressionList.html">ExpressionList</a> class for more details.
</p>


<p>
Ebean will automatically add SQL joins if they are required for the where clause or order by clause (and the matching joins are not explicitly included).
</p>

```java
List<Order> orders =
    Ebean.find(Order.class)
        .where().ilike("customer.name", "rob%")
        .findList();
```

... in the sql below, the join to or_customer is automatically added to support the where clause.

```xml
<sql summary='[app.data.test.Order]'>
select o.id, o.order_date, o.ship_date, o.cretime, o.updtime, o.status_code, o.customer_id
from or_order o
join or_customer c on o.customer_id = c.id
where lower(c.name) like ?
<sql>
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="query_language">Ebean query language</h2>
<p>Ebean has it's own query language. Prior to this decision JPQL (the JPA query language)
was investigated to see if it would meet the desired goals of Ebean and it did not.
Specifically the desire for Ebean is to support "Partial Objects" via the query language and it is difficult to
see how JPQL will evolve to support this (specifically difficulties around its select clause).
</p><p>
Apart from "Partial Object" support there was also a desire to simplify the join syntax,
specifically Ebean will automatically determine the type of join (outer join etc) for you and
also automatically add joins to support predicates and order by clauses.
</p><p>
JPQL is more powerful with the ability to mix entity beans with scalar values returning
Object[]. However, this feature also could be a major stumbling block for it to evolve
support for partial objects for any node in the object graph.
</p><p>
In summary you could say the Ebean query language is much simplier that JPQL with the
benefit of proper support for "Partial Objects" for any node in the object graph (this is not
possible with JPQL in it's current form).
</p><p>
"Partial Object" support in Ebean is important for design reasons and performance
reasons. From a performance perspective your queries are more performant if they fetch
less data back from the database. From a design perspective you do not need to model
using secondary tables but instead use partial objects at any depth in the query.
</p><p>
For example, to build an object graph for an Order you may want some product
information for each orderDetail.
</p>

<p>Examples
```groovy
// find all the orders fetching all the properties of order
find order

// find all the orders fetching all the properties of order
// ... this is the same as the first query
find order (*)

// find all the orders fetching the id, orderDate and shipDate
// ... This is described as a "partial object query"
// ... the ID property is *ALWAYS* fetched
find order (orderDate, shipDate)

// find all the orders (and orderDetails)
// ... fetching all the properties of order
// ... and all the properties of orderDetails
// ... the type of fetch(Outer etc) is determined automatically
find order
fetch orderDetails

// find all the orders (with their orderDetails)
// ... fetching all the properties of order
// ... and all the properties of orderDetails
find order (*)
fetch orderDetails (*)

// find all the orders (with orderDetails and products)
// ... fetching the order id, orderDate and shipDate
// ... fetching all the properties for orderDetail
// ... fetching the product id, sku and name
find order (orderDate, shipDate)
fetch orderDetails (*)
fetch orderDetails.product (sku, name)
```

```java
String query = "find order where status.code=:status and shipDate > :shipped";

List<Order> list = Ebean.find(Order.class)
    .setQuery(query)
    .setParameter("status", Order.Status.SHIPPED)
    .setParameter("shipped", lastWeek)
    .findList();
```

```xml
<sql summary='[app.data.test.Order] autoFetchTuned[false]'>
select o.id, o.order_date, o.ship_date, o.cretime, o.updtime, o.status_code, o.customer_id
from or_order o
where o.status_code = ? and o.ship_date > ?
</sql>
```


<p>Every object in the object graph can be a partial object. This is what you can't do in JPQL
currently.</p>

<p>These Partially populated objects are will lazy load as required and are fully updatable etc.
You can treat them just like fully populated objects.</p>

<p>Autofetch can use partial objects to only fetch the properties that the application actually
uses. In this way you can get the performance of partial objects without any work on your
part (Autofetch determines the joins and properties to fetch for you).</p>


<#-------------------------------------------------------------------------------------------------->
<h2 id="partial_objects">Partial objects</h2>
  <p>
      The Query object has select() and fetch() methods and these allow you to specify
      the properties that should be fetched.
  </p>
  <p>This can be a very significant performance benefit by only fetching the properties you need. If the properties are in DB indexes then the DB doesn't have to read Index Blocks. This is also a design benefit in that it removes the "fixed" design constraints of using secondary table properties.</p>

  <p>Note that <a href="#autofetch">Autofetch</a> can use profiling to specify the properties to select rather than you manually doing so (which saves you the work).</p>

  <h4>Select</h4>
  <p>
      With select you specify the properties that should be fetched on the root level type.
  </p>
  <p>
        Partially loading a bean or object graph using select() and fetch().
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
  </p>
  <h4>Fetch</h4>
  <p>
      With fetch you specify the properties that should be fetched on the associated beans.
  </p>

  <p>*ANY* node of the object graph can be a partial object. This example shows several ways partial objects can be fetched.

```java
  Order order = Order.find
    .select("status, orderDate, shipDate") // 3 fields from order
    .fetch("customer", "name") // just name field from customer
    .fetch("details")  // all fields from details
    .fetch("details.product", "sku")  // just sku field from product
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
  </p>

<h4>Saving a partial object</h4>

<p>
You can save or delete a Partial Object.
</p>

```java
// find customer 1
// ... just fetch the customer id, name and version property
Customer customer = Ebean.find(Customer.class)
        .select("name")
        .where().idEq(1)
        .findUnique();

customer.setName("CoolName");

Ebean.save(customer);
```

<p>
The query generates the following SQL...
```xml
<sql summary='[app.data.test.Customer]'>
select c.id, c.name
from or_customer c
where c.id = ?
</sql>
```
</p>
<p>and in the transaction logs we can find the update dml and bind values.</p>
```xml
... update or_customer set name=?, updtime=? where id=? and name=?
... Binding Update [or_customer]  set[name=CoolName, updtime=2008-11-19 10:58:08.598, ] where[id=1, name=Ford, ]
... Updated [app.data.test.Customer] [1]
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="query_joins">Query joins</h2>
<h4>
    Controlling eager loading of the object graph using query joins.
</h4>
<p>You can use fetch() to explicitly state which additional paths you want to fetch. You would do this to reduce "lazy loading" of those beans later.</p>
<p>
  When more than 1 OneToMany or ManyToMany relationship is eagerly fetched
    then Ebean will automatically convert one of those into a 'Query Join'. Ebean does this so that it avoids
    generating a cartesian product query. Note that Ebean determines the type of SQL join for you based on the cardinality and optionality of the relationship.
</p>
<h4>Example 1</h4>
<p>
    It this example both "customer.contacts" and "details" are OneToMany relationships.
```java
List<Order> orders = Order.find
    .select("status")
    .fetch("customer")
    .fetch("customer.contacts")       // contacts is a @OneToMany
    .fetch("details")                 // details is a @OneToMany
    .orderBy("customer.name")
    .findList();
```

... results in the "left outer join o_contact" and related t2.* columns being included in the query (so they won't be lazy loaded later).

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
</p>


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
<h2 id="fetchconfig">FetchConfig</h2>

<p>When you specify a Query with Ebean it can result in more than 1 SQL query. Sometimes
you want explicit control over this (what the secondary queries are, batch size used, eager
or lazily invoked)</p>

<p>FetchConfig gives you the ability to specify these "secondary queries" and let them
executed lazily ("lazy loading join") or eagerly ("query join").</p>


<p>Note that explicitly using FetchConfig is not a requirement.  Ebean is able to automatically convert some joins
  to "query joins" when it is needed such as when building object graphs with multiple *ToMany relationships or when limit offset
is used with a *ToMany relationship.</p>


<p>You use FetchConfig to define that you want to use a separate SQL query to fetch that part of the object graph (to use a "query join" rather than a "fetch join"). What this means is that Ebean will use 2 SQL queries rather than 1 to build the object graph.
</p>

<p>Note that you do not need to expicitly use FetchConfig if you don't want to. In that case Ebean will automatically convert any fetch paths over to use FetchConfig if it needs to (multiple *ToMany relationships etc).
</p>

<p>FetchConfig defines the configuration options for a "query fetch" or a "lazy loading fetch". This gives you the ability to use multiple smaller queries to populate an object graph as opposed to a single large query. The primary goal is to provide efficient ways of loading complex object graphs avoiding SQL Cartesian product and issues around populating object graphs that have multiple *ToMany relationships.  It also provides the ability to control the lazy loading queries (batch size, selected properties and fetches) to avoid N+1 queries etc.
</p>

<p>
There can also be cases loading across a single OneToMany where 2 SQL queries using Ebean FetchConfig.query() can be more efficient than one SQL query. When the "One" side is wide (lots of columns) and the cardinality difference is high (a lot of "Many" beans per "One" bean) then this can be more efficient loaded as 2 SQL queries.
</p>

<p>The reason for using "Query Joins" as opposed to "Fetch joins" is that there are some
cases where using multiple queries is more efficient that a single query.<p>

<p>Any time you want to load multiple OneToMany associations it will likely be more
performant as multiple SQL queries. If a single SQL query was used that would result in a
Cartesian product.</p>

<p>There can also be cases loading across a single OneToMany where 2 SQL queries (using
Ebean "query join") can be more efficient than one SQL query (using Ebean "fetch join").
When the "One" side is wide (lots of columns) and the cardinality difference is high (a lot
of "Many" beans per "One" bean) then this can be more efficient loaded as 2 SQL queries.</p>


<p>
Example: Find Orders join details using a single SQL query
```java
// Normal fetch join results in a single SQL query
List<Order> list = Ebean.find(Order.class).fetch("details").findList();
```
<p>

<p>
Example: Using a "query join" instead of a "fetch join" we instead use 2 SQL queries

```java
// This will use 2 SQL queries to build this object graph.
List<Order> list =
    Ebean.find(Order.class)
        .fetch("details", new FetchConfig().query())
        .findList();
```
queries:
<ol><li>find order</li>
<li>find orderDetails where order.id in (?,?...) // first 100 order id's</li>
</ol>
</p>


<p>
Example: Using 2 "query joins"

```java
// This will use 3 SQL queries to build this object graph
List<Order> list =
    Ebean.find(Order.class)
        .fetch("details", new FetchConfig().query())
        .fetch("customer", new FetchConfig().queryFirst(5))
        .findList();
```
queries:
<ol><li>find order</li>
<li>find orderDetails where order.id in (?,?...) // first 100 order id's</li>
<li>find customer where id in (?,?,?,?,?) // first 5 customers</li>
</ol>
</p>

<p>
Example: Using "query joins" and partial objects

```java
// This will use 3 SQL queries to build this object graph
List<Order> list =
    Ebean.find(Order.class)
        .select("status, shipDate")
        .fetch("details", "quantity, price", new FetchConfig().query())
        .fetch("details.product", "sku, name")
        .fetch("customer", "name", new FetchConfig().queryFirst(5))
        .fetch("customer.contacts")
        .fetch("customer.shippingAddress")
        .findList();
```
queries:
<ol><li>find order (status, shipDate)</li>
<li>find orderDetail (quantity, price) fetch product (sku, name) where order.id in (?,? ...)</li>
<li>find customer (name) fetch contacts (*) fetch shippingAddress (*) where id in (?,?,?,?,?)</li>
</ol>
Note: the fetch of "details.product" is automatically included into the fetch of "details"<br>
Note: the fetch of "customer.contacts" and "customer.shippingAddress" are automatically included in the fetch of "customer"
</p>

<p>You can use query() and lazy together on a single join. The query is executed immediately and the lazy defines the batch size to use for further lazy loading (if lazy loading is invoked).

```java
List<Order> list =
    Ebean.find(Order.class)
        .fetch("customer", new FetchConfig().query(10).lazy(5))
        .findList();
```
queries:
<ol><li>find order</li>
<li>find customer where id in (?,?,?,?,?,?,?,?,?,?) // first 10 customers</li>
<li>then if lazy loading of customers is invoked, use a batch size of 5 to load the customers</li>
</ol>
</p>

<p>
Example of controlling the lazy loading query:
</p>
<p>
This gives us the ability to optimise the lazy loading query for a given use case.

```java:
List<Order> list = Ebean.find(Order.class)
  .fetch("customer","name", new FetchConfig().lazy(5))
  .fetch("customer.contacts","contactName, phone, email")
  .fetch("customer.shippingAddress")
  .where().eq("status",Order.Status.NEW)
  .findList();
```
queries:
<ol><li>find order where status = Order.Status.NEW</li>
  <li>if lazy loading of customers is invoked, use a batch size of 5 to load the customers.</p>
</ol>

Note: when the laxy loading of customers is performed, it perform like:
```xml
      find  customer (name)
      fetch customer.contacts (contactName, phone, email)
      fetch customer.shippingAddress (*)
      where id in (?,?,?,?,?)
```


<p>Example of wo "Query Joins" results in 3 SQL queries used to build an object graph
```java
// A more advanced example with multiple query joins
List<Order> l0 = Ebean.find(Order.class)
  .select("status, shipDate")
  .fetch("details", "orderQty, unitPrice", new FetchConfig().query())
  .fetch("details.product", "sku, name")
  .fetch("customer", "name", new FetchConfig().query(10))
  .fetch("customer.contacts","firstName, lastName, mobile")
  .fetch("customer.shippingAddress","line1, city")
  .findList();
```

The resulting 3 sql queries are:
</p>
<p>
Query 1 - the main query - Note: customer_id was automatically added to support query join.
```xml
// query 1 … the main query
<sql summary='Order' >
select o.id c0, o.status c1, o.ship_date c2, o.customer_id c3
from o_order o
</sql>
```
</p>
<p>
Query 2 - query join on customer - fetching the first 10 customers referenced (batch:10) but there where actually only 2 to fetch (actual:2).
```xml
<sql mode='+query' summary='Customer, shippingAddress
+many:contacts' load='path:customer batch:10 actual:2' >
select c.id c0, c.name c1
, cs.id c2, cs.line_1 c3, cs.city c4
, cc.id c5, cc.first_name c6, cc.last_name c7, cc.mobile c8
from o_customer c
left outer join o_address cs on cs.id = c.shipping_address_id
left outer join contact cc on cc.customer_id = c.id
where c.id in (?,?,?,?,?,?,?,?,?,?)
order by c.id
</sql>
```
</p>
<p>
Query 3 – query join on details - fetching the order details for the first 100 orders (batch:100).
```xml
<sql mode='+query' summary='Order +many:details, details.product'
load='path:details batch:100 actual:3' >
select o.id c0
, od.id c1, od.order_qty c2, od.unit_price c3
, odp.id c4, odp.sku c5, odp.name c6
from o_order o
left outer join o_order_detail od on od.order_id = o.id
left outer join o_product odp on odp.id = od.product_id
where o.id in (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
order by o.id
</sql>
```

<h4>FetchConfig.lazy() - "Lazy Joins"</h4>

<p>If a join is not defined at all (neither a fetch join or a query join) – then lazy loading will by
default just fetch all the properties for that entity.
</p><p>
FetchConfig.lazy() allows you to control that lazy loading query – define the batch size,
properties to select and also fetch paths to include on the lazy load query.
</p><p>
This is very similar to a "query join" except that the loading occurs on demand (when the
property is requested and not already loaded).
</p><p>
The reason you would want to control the lazy loading query is to optimise performance
for further lazy loading (avoid N+1 queries, define joins that should be included for lazy
loading queries, load only the properties required and no more).
</p><p>
Example: Control the query used to lazy load
```java
// control the lazy loading of customers ...
List<Order> list = Ebean.find(Order.class)
  .fetch("customer","name", new FetchConfig().lazy(5))
  .fetch("customer.contacts","contactName, phone, email")
  .fetch("customer.shippingAddress")
  .where().eq("status",Order.Status.NEW)
  .findList();
```
</p><p>
In the example above the orders are loaded. Only when the application requests a
customer property (that is not the customer's id) then the lazy loading of the customer is
invoked. At that point the customer name is loaded, with the contacts and
shippingAddress – this is done in batch of 5 customers.
</p><p>
Note that if the customer status is requested (rather than the customer name) and that
invokes the lazy loading then all the customer's properties are loaded (rather than just the
customers name).

```java
Order order = list.get(0);
Customer customer = order.getCustomer();

// this invokes the lazy loading of 5 customers
String name = customer.getName();
```
</p><p>
The resulting lazy loading query is …
```xml
<sql mode='+lazy' summary='Customer, shippingAddress +many:contacts' load='path:customer batch:5 actual:2' >
  select c.id c0, c.name c1, cs.id c2, cs.line_1 c3, cs.line_2 c4, cs.city c5,
          cs.cretime c6, cs.updtime c7, cs.country_code c8,
          cc.id c9, cc.phone c10, cc.email c11
  from o_customer c
  left outer join o_address cs on cs.id = c.shipping_address_id
  left outer join contact cc on cc.customer_id = c.id
  where c.id in (?,?,?,?,?)
  order by c.id
</sql>
```

<h4>Using both</h4>

<p>You can use both queryFirst() and lazy() on a single join. The queryFirst() part defines the
number of beans that will be loaded eagerly via an additional query and then lazy defines
the batch size of the lazy loading that occurs after than (if there is any).

```java
new FetchQuery.queryFirst(100).lazy(10);
```

</p>

<h4>+query and +lazy – query language syntax</h4>
<p>
To define "query joins" and "lazy joins" in the query language you can use +query and
+lazy. Optionally you can specify the batch size for both.

```groovy
find order
join customers (+query )
where status = :status
```

```groovy
find order (status, shipDate)
join customers (+lazy(10) name, status)
where status = :orderStatus
```
</p>


<#-------------------------------------------------------------------------------------------------->
<h2 id="lazy_loading">Lazy loading</h2>
<h4>
Fine grained control over lazy loading.
</h4>
<p>
A Partial Object will lazy load the rest of the data on demand when you get or set a property it does not have.
</p>

```java
// find order 12
// ... fetching the order id, orderDate and version property
// .... nb: the Id and version property are always fetched

Order order = Ebean.find(Order.class)
        .select("orderDate")
        .where().idEq(12)
        .findUnique();

// shipDate is not in the partially populated order
// ... so it will lazy load all the missing properties
Date shipDate = order.getShipDate();

// similarly if we where to set the shipDate
// ... that would also trigger a lazy load
order.setShipDate(new Date());
```

<p>
Lazy loading occurs automatically when you set or get a property that the partially populated bean does not have.
</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="named_queries">Named Queries</h2>

```java
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

...
@NamedQueries(value={
      @NamedQuery(
          name="bugsSummary",
          query="find (name, email) fetch loggedBugs (title, status) where id=:id "),
      @NamedQuery(
          name="bugStatus",
          query="fetch loggedBugs where loggedBugs.status = :bugStatusorder by name")
})
@Entity
@Table(name="s_user")
public class User implements Serializable {
...
```
<p>You can have named queries, where you define the query. Note that the names of the
queries are per entity type (not global as they are in JPA).</p>

<p>Once you get a named query you set any named parameters and then execute it – in the
case below we use findUnique() as we expect only one object graph returned.</p>

```java
User u = Ebean.createNamedQuery(User.class, "bugsSummary")
  .setParameter("id", 1)
  .findUnique();
```

<h4>Named Queries are Modifyable</h4>
<p>Named queries are parsed early and returned as query objects to you that you can
modify. This means that you can get a named query and then modify the query by adding
to the where clause, setting the order by, limits etc.</p>

<p>This is an intentional feature and means that you can use Named Queries as a "starting
point" to then modify via code and execute.</p>
```java
// you can treat namedQueries as starting points...
// ... in that you can modify them via code
// ... prior to executing the query
// you can modify a named query...
Set<User> users = Ebean.createQuery(User.class, "bugStatus")
  .setParameter("bugStatus", "NEW")

// you can add to the where clause
  .where().ilike("name", "rob%")

// you can set/override the order by
  .orderBy("id desc")

// you can set/override limits (max rows, first row)
  .setMaxRows(20)
  .findSet();
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="large_queries">Large queries</h2>

<p>Large query results can take up a lot of memory if using findList() since loads all the results in memory at once.
  Ebean provides functionality for streaming the results.  With this functionality, you process the results rows one at a time.</p>

<p><b>Query.findIterate()</b> - Execute the query iterating over the results. Requires calling QueryIterator.close(), typically in a finally block, to prevent resource leakage.

<p><b>Query.findEach(QueryEachConsumer<T> consumer)</b> - Execute the query consuming each bean one at a time. </p>
<o>
This method is appropriate to process very large query results as the beans are consumed one at a time and do not need to be held in memory (unlike #findList #findSet etc)
</p><p>Note that internally Ebean can inform the JDBC driver that it is expecting larger resultSet and specifically for MySQL this hint is required to stop it's JDBC driver from buffering the entire resultSet. As such, for smaller resultSets findList() is generally preferable.
</p><p>
Compared with findEachWhile() this will always process all the beans where as findEachWhile() provides a way to stop processing the query result early before all the beans have been read.
</p><p>
This method is functionally equivalent to findIterate() but instead of using an iterator uses the QueryEachConsumer (SAM) interface which is better suited to use with Java8 closures.
</p><p>
```java
 ebeanServer.find(Customer.class)
    .where().eq("status", Status.NEW)
    .order().asc("id")
    .findEach((Customer customer) -> {

      // do something with customer
      System.out.println("-- visit " + customer);
    });
```

<p><b>Query.findEachWhile(QueryEachWhileConsumer<T> consumer)</b> - >Execute the query using callbacks to a visitor to process the resulting beans one at a time.</p>
<p>
   This is similar to .findEach(...) except that you return boolean true to continue processing beans and return false to stop processing early.
</p><p>
This method is functionally equivalent to findIterate() but instead of using an iterator uses the QueryEachWhileConsumer (SAM) interface which is better suited to use with Java8 closures.
</p>
```java
 ebeanServer.find(Customer.class)
    .fetch("contacts", new FetchConfig().query(2))
    .where().eq("status", Status.NEW)
    .order().asc("id")
    .setMaxRows(2000)
    .findEachWhile((Customer customer) -> {

      // do something with customer
      System.out.println("-- visit " + customer);

      // return true to continue processing or false to stop
      return (customer.getId() < 40);
    });
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="paging">Paging</h2>

<p>Paging through the results means that instead of all the results are not fetched in a single query Ebean will use SQL to limit the results (limit/offset, rownum, row_number() etc).</p>

<h4>
Using firstRows and maxRows or findPagedList to fetch a 'page' of results.
</h4>
<p>
If you are building a stateless application (not holding the PagingList over multiple requests) then this approach is a good option.
</p><p>
Use setFirstRow() and setMaxRows() to control what rows are returned for the Query..
</p><p>

</p>

<h4>PagedList</h4>

<p>The benefit of using PagedList over just using the normal Query with Query.setFirstRow(int) and Query.setMaxRows(int) is that it additionally wraps functionality that can call Query.findFutureRowCount() to determine total row count, total page count etc.</p>

<p>Internally this works using Query.setFirstRow(int) and Query.setMaxRows(int) on the query. This translates into SQL that uses limit offset, rownum or row_number function to limit the result set.</p>

<p>
  Example: typical use including total row count

```java
// We want to find the first 100 new orders
//  ... 0 means first page
//  ... page size is 100

PagedList<Order> pagedList
      = ebeanServer.find(Order.class)
      .where().eq("status", Order.Status.NEW)
      .order().asc("id")
      .findPagedList(0, 100);

// Optional: initiate the loading of the total
// row count in a background thread
pagedList.loadRowCount();

// fetch and return the list in the foreground thread
List<Order> orders = pagedList.getList();

// get the total row count (from the future)
int totalRowCount = pagedList.getTotalRowCount();
```

Example: No total row count required
```java
    // If you are not getting the 'first page' often
    // you do not bother getting the total row count again
    // so instead just get the page list of data

    // fetch and return the list in the foreground thread
    List<Order> orders = pagedList.getList();
```
</p>


<#-------------------------------------------------------------------------------------------------->
<h2 id="async_queries">Asynchronous queries</h2>

<p>
Ebean has built in support for executing queries asynchronously. These queries are executed in a background thread and "Future" objects are returned.
The "Future" objects returned extend java.util.concurrent.Future. This provides support for cancelling the query, checking if it is cancelled or done and getting the result with waiting and timeout support.
</p>


Methods on Query for ansychronous execution

```java
public FutureList<T> findFutureList();

public FutureIds<T> findFutureIds();

public FutureRowCount<T> findFutureRowCount();
```


example: shows the use of FutureList:

```java
Query<Order> query = Ebean.find(Order.class);

// find list using a background thread
FutureList<Order> futureList = query.findFutureList();

// do something else ...

if (!futureList.isDone()){
    // you can cancel the query. If supported by the JDBC
    // driver and database this will actually cancel the
    // sql query execution on the database
    futureList.cancel(true);
}
// wait for the query to finish ... no timeout
List<Order> list = futureList.get();

// wait for the query to finish ... with a 30sec timeout
List<Order> list2 = futureList.get(30, TimeUnit.SECONDS);
```


<#-------------------------------------------------------------------------------------------------->
<h2 id="rawsql">RawSql</h2>
<h4>
Using RawSql to fully control the SQL used to load an object graph.
</h4>

<o>
You can explicitly specify the SQL to use and have that mapped into Objects. You may want to do this so use aggregate functions like sum() max() etc or in cases where you just need exact control over the SQL.
</p>
<p>
  This is useful for "Reporting" type requirements where you want to use aggregate functions such as sum(), count(), max(), etc.  It is also useful if you need to use Database specific SQL for whatever reason.</p>

<p>
You can programmatically use raw SQL like the following examples or put the Raw SQL and column mappings into ebean-orm.xml file and reference them as 'named queries' - see ebeanServer.createNamedQuery().
</p>

<p>You can use RawSql with ebean enhanced entity beans.  You can fetch only the properties that are need (creating partially populated entity beans). All ebean enhanced entity beans built with RawSql invoke lazy loading etc and act just the same as if they where populated via Ebean generated SQL.</p>

<p>
If you let Ebean 'parse' the raw SQL then Ebean can add expressions to the WHERE and HAVING clauses as well as set the ORDER BY and LIMIT OFFSET clauses.


```java
// Use raw SQL with an aggregate function

String sql
    = " select order_id, o.status, c.id, c.name, sum(d.order_qty*d.unit_price) as totalAmount"
    + " from o_order o"
    + " join o_customer c on c.id = o.kcustomer_id "
    + " join o_order_detail d on d.order_id = o.id "
    + " group by order_id, o.status ";

RawSql rawSql =
    RawSqlBuilder
        // let ebean parse the SQL so that it can
        // add expressions to the WHERE and HAVING
        // clauses
        .parse(sql)
        // map resultSet columns to bean properties
        .columnMapping("order_id",  "order.id")
        .columnMapping("o.status",  "order.status")
        .columnMapping("c.id",      "order.customer.id")
        .columnMapping("c.name",    "order.customer.name")
        .create();


Query<OrderAggregate> query = Ebean.find(OrderAggregate.class);
    query.setRawSql(rawSql)
    // add expressions to the WHERE and HAVING clauses
    .where().gt("order.id", 0)
    .having().gt("totalAmount", 20);

List<OrderAggregate> list = query.findList();
```
</p>

<p>
This example uses FetchConfig to fetch other parts of the object graph. After the raw SQL query is executed Ebean uses 'query joins' to fetch some order and customer properties.

```java
// You can also use FetchConfig to get Ebean to
// fetch additional parts of the object graph
// after the Raw SQL query is executed.

String sql
    = " select order_id, sum(d.order_qty*d.unit_price) as totalAmount "
    + " from o_order_detail d"
    + " group by order_id ";

RawSql rawSql =
    RawSqlBuilder
        .parse(sql)
        .columnMapping("order_id",  "order.id")
        .create();


Query<OrderAggregate> query = Ebean.find(OrderAggregate.class);
query.setRawSql(rawSql)
    // get ebean to fetch parts of the order and customer
    // after the raw SQL query is executed
    .fetch("order", "status,orderDate",new FetchConfig().query())
    .fetch("order.customer", "name")
    .where().gt("order.id", 0)
    .having().gt("totalAmount", 20)
    .order().desc("totalAmount")
    .setMaxRows(10);
 ```
 </p>

<p>
This is the OrderAggregate bean used in the examples above.

```java
package com.avaje.tests.model.basic;

import javax.persistence.Entity;
import javax.persistence.OneToOne;

import com.avaje.ebean.annotation.Sql;

/**
 * An example of an Aggregate object.
 *
 * Note the @Sql indicates to Ebean that this bean is not based on a table but
 * instead uses RawSql.
 *
 */
@Entity
@Sql
public class OrderAggregate {

    @OneToOne
    Order order;

    Double totalAmount;

    Double totalItems;

    public String toString() {
        return order.getId() + " totalAmount:" + totalAmount + " totalItems:" + totalItems;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Double getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(Double totalItems) {
        this.totalItems = totalItems;
    }
}
```
</p>

<h4>tableAliasMapping()</h4>
tableAliasMapping() will automatically map columns from the query results to the associated object based on its path.  It does this using the query alias.  This is a convenience mathod so that you don't have to map each column individually.

<p>So a test case looks like:

```java
String rs = "select o.id, o.status, c.id, c.name, "+
        " d.id, d.order_qty, p.id, p.name " +
        "from o_order o join o_customer c on c.id = o.kcustomer_id " +
        "join o_order_detail d on d.order_id = o.id  " +
        "join o_product p on p.id = d.product_id  " +
        "where o.id <= :maxOrderId  and p.id = :productId "+
        "order by o.id, d.id asc";


RawSql rawSql = RawSqlBuilder.parse(rs)
        .tableAliasMapping("c", "customer")
        .tableAliasMapping("d", "details")
        .tableAliasMapping("p", "details.product")
        .create();

List<Order> ordersFromRaw = Ebean.find(Order.class)
        .setRawSql(rawSql)
        .setParameter("maxOrderId", 2)
        .setParameter("productId", 1)
        .findList();
```

Rather than using columnMapping like:

```java
RawSql rawSql = RawSqlBuilder.parse(rs)
        .columnMapping("t0.id", "id")
        .columnMapping("t0.status", "status")
        .columnMapping("t1.id", "customer.id")
        .columnMapping("t1.name", "customer.name")
        .columnMapping("t2.id", "details.id")
        .columnMapping("t2.order_qty", "details.orderQty")
        .columnMapping("t3.id", "details.product.id")
        .columnMapping("t3.name", "details.product.name")
        .create();
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="sqlquery">SqlQuery</h2>
<h4>
Performing sql queries returning relational SqlRow's rather than beans / object graphs.
</h4>

<p>SqlQuery is where you specify the exact SQL SELECT statement and returns list, sets or maps of SqlRow objects. A SqlRow is a Map where the key is the column name.<p>

<p>This is a fairly lightweight API that you could use instead of going to raw JDBC (which is of course an option).</p>

```java
String sql = "select b.id, b.title, b.type_code, b.updtime"
          +" ,p.name as product_name "
          +"from b_bug b join b_product p on p.id = b.product_id "
          +"where b.id = :id";
SqlRow bug = Ebean.createSqlQuery(sql)
  .setParameter("id", 1)
  .findUnique();
String prodName = bug.getString("product_name");
String title = bug.getString("title");
```
<p>Note that you can use "Named" queries and put the sql statements in orm.xml rather than having it in your code.</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="l2cache">L2 Cache</h2>
<h4>
How to use the L2 cache with queries.
</h4>
...(under construction)...


<#-------------------------------------------------------------------------------------------------->
<h2 id="autofetch">Autofetch</h2>
<h4>
Let Ebean automatically tune you queries using Autofetch.
</h4>
<p>Ebean can automatically tune your queries for you using a feature called "Autofetch". This has the benefit of executing better performing queries that and reduced lazy loading.</p>

<p>Autofetch automatically modifies your queries – essentially controlling the select() and
fetch() clauses to fetch all the data your application uses but no more. This has the effect
of reducing the amount of lazy loading and only fetches properties that are actually used</p>
<p>
  Autofetch can also be used with a query that you have explicitly specified some
  fetch() paths. Autofetch can add additional fetch() paths and tune which properties to fetch
  per path.</p>

<p>
Example: a program that fetches some orders ... and processes them
```  java
// fetch new orders
List<Order> orders =
    Ebean.find(Order.class)
        .where().eq("status", Order.Status.NEW)
        .findList();

// just read the orderDate
for (Order order : orders) {
    Date orderDate = order.getOrderDate();
}
```
</p>
<p>
Initially Ebean has no "profiling" information so when the program is first run the query executed is not optimal.
</p>

```xml
<sql summary='[app.data.test.Order]'>
select o.id, o.order_date, o.ship_date, o.cretime, o.updtime, o.status_code, o.customer_id
from or_order o
where o.status_code = ?
<sql>
```
<p>
However, now that we have run the program once Ebean has collected some profiling information. Specifically it knows that for this query (based on the call stack) the program only reads the orderDate. So when we run the program a 2nd time...
</p>

```xml
<sql summary='[app.data.test.Order] autoFetchTuned[true]'>
select o.id, o.order_date, o.updtime
from or_order o
where o.status_code = ?
<sql>
```

<p>
You will note the autoFetchTuned[true] on the output. This indicates that this query was tuned via Autofetch. In this case, the profiling indicated that only the orderDate property was used so that, along with the Id property and the version column are the only properties fetched.
</p>

<p>
example: Now lets change the program. We will use another property of order and we will also get the customers name.
</p>
```java
List<Order> orders =
    Ebean.find(Order.class)
        .where().eq("status", Order.Status.NEW)
        .findList();

for (Order order : orders) {
    Date orderDate = order.getOrderDate();
    // also get the ship date
    Date shipDate = order.getShipDate();
    // ... and get the customer name
    Customer customer = order.getCustomer();
    String customerName = customer.getName();
}
```
<p>
The query Ebean will run is optimised for what the program USED to do. This results in some lazy loading occuring. The rest of the order is lazy loaded when the shipDate is read... and then the customer is lazy loaded when the customer name is read.
</p>

```xml
<sql summary='[app.data.test.Order] autoFetchTuned[true]'>
select o.id, o.order_date, o.updtime
from or_order o
where o.status_code = ?
</sql>
```
-- LAZY LOADING: ... due to reading shipDate
```xml
<sql summary='[app.data.test.Order]'>
select o.id, o.order_date, o.ship_date, o.cretime, o.updtime, o.status_code, o.customer_id
from or_order o
where o.id = ?
</sql>
```

-- LAZY LOADING: ... due to reading customers name
```xml
<sql summary='[app.data.test.Customer]'>
select c.id, c.name, c.cretime, c.updtime, c.billing_address_id, c.status_code, c.shipping_address_id
from or_customer c
where c.id = ?
<sql>
```

<p>
So the above queries are not so good. However, Ebean has now updated its profiling information so when we run the program again...
</p>

```xml
<sql summary='[app.data.test.Order, customer] autoFetchTuned[true]'>
select o.id, o.order_date, o.updtime, o.ship_date
        , c.id, c.name, c.updtime
from or_order o
join or_customer c on o.customer_id = c.id
where o.status_code = ?
<sql>
```

<p>
... now Ebean has added the shipDate and a join to customer fetching the customer name.
</p>

<p>So, if you turn on autoFetch Ebean can optimise your queries based on how the object graphs are actually used by the application. The developer has less work by not having to define joins and you get the performance benefits of partial objects with no work - nice.
</p>

<p>
Autofetch can continue to update its profiling information so that when your application changes the queries will automatically be tuned to suit.
</p>


<h4>Explicit control on queries</h4>
<p>On the query object you can explicitly specify if you want to use autofetch or not.
```java
// explicitly turn on Autofetch for this query
query.setAutofetch(true);
```
</p>

<h4>Implicit control from configuration</h4>
<p>There are a number of properties in ebean.properties which control how autofetch works.

```properties
# enable autofetch
ebean.autofetch.querytuning=true
# enable collection of profiling information
ebean.autofetch.profiling=true
# implicit autofetch mode
# default_off, default_on, default_on_if_empty
ebean.autofetch.implicitmode=default_on
# minimum amount of profiling to collect before
# autofetch will start tuning the query
ebean.autofetch.profiling.min=1
# profile every query up to base
ebean.autofetch.profiling.base=10
# after base collect profiling on 5% of queries
ebean.autofetch.profiling.rate=0.05
```
<table class="table">
<tr><th>property</th><th>type/values</th><th>description</th></tr>
<tr><td>ebean.autofetch.querytuning</td><td>boolean</td><td>If true enables Autofetch to tune queries</td></tr>
<tr><td>ebean.autofetch.profiling</td><td>boolean</td><td>If true enables profiling information to be collected</td></tr>
<tr><td>ebean.autofetch.implicitmode</td><td>default_off<br>default_on<br>default_on_if_empty</td><td>default_on_if_empty means autofetch will only tune the query if neither select() nor fetch() has been explicitly set on the query.</td></tr>
<tr><td>ebean.autofetch.profiling.min</td><td>integer</td><td>The minimum amount of profiled queries to be collected before the automatic query tuning will start to occur</td></tr>
<tr><td>ebean.autofetch.profiling.base</td><td>integer</td><td>Will profile every query up to this number and after than will profile based on the profiling.rate (5% of queries etc)</td></tr>
<tr><td>ebean.autofetch.profiling.rate</td><td>float</td><td>The percentage of queries that are profiled after the base number has been collected</td></tr>
</table>
</p>


<h4>JMX and Programatic Control of Autofetch</h4>
<td>You can manage Autofetch at runtime either via JMX or programmatically.</td>
```java
// get the 'default' EbeanServer
EbeanServer server = Ebean.getServer(null);
AdminAutofetch adminAutofetch = server.getAdminAutofetch();

// change autofetch properties at runtime
adminAutofetch.setQueryTuning(false);
adminAutofetch.setProfiling(false);
adminAutofetch.setProfilingRate(0.50f);
adminAutofetch.clearProfilingInfo();
adminAutofetch.clearTunedQueryInfo();
```


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
  <li>Fetching the 'row count'.</li>
</ul>
...(under construction)...


</div>
