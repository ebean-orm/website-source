<div class="bs-docs-section">
<h1 id="introduction" class="page-header">Introduction</h1>

<div class="row">
<div class="col-md-3">
  <div class="well">
  <h4>Simple to learn</h4>
  <p>
Ebean's goal is to be simple to use and understand. Developers should be able to be productive quickly and get stuff done without fuss or worry.
  </p>
  </div>
</div>

<div class="col-md-3">
  <div class="well">
  <h4>Elegant</h4>
  <p>
Large queries, batch processing, need to use raw SQL  - Ebean will elegantly handle your more difficult requirements.
  </p>
  </div>
</div>

<div class="col-md-3">
  <div class="well">
  <h4>Performance</h4>
  <p>
Ebean is designed for performance. Fetch only what you need using 'partial objects', query joins, batch lazy loading.
  </p>
  </div>
</div>
</div> <#-- ./row -->



<div class="row">
<div class="col-md-12">

<#-------------------------------------------------------------------------------------------------->
<h2 id="use_jpa_mapping">Use JPA Mapping</h2>
<p>
Use standard JPA Mapping annotations - @Entity, @Table, @Id etc.
</p>

```java

/**
 * Use standard JPA Mapping annotations.
 */
@Entity
@Table(name = "o_customer")
public class Customer {

  @Id
  Long id;

  @Version
  Long version;

  String name;

  @ManyToOne
  Address address;

  @OneToMany(mappedBy = "customer")
  List<Order> orders;

  // getters and setters

}
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="simple_query_language">Simple query language</h2>
<p>
Ebean provides a simple query language. It will determine what joins are required to support your WHERE clause and add them as appropriate
so that the developer can concentrate on  by doing some of the work for you.
</p>

<h4>Example - find by id:</h4>
```java
@Inject
EbeanServer server;
...

  // find customer by id
  Customer customer = server.find(Customer.class, customerId);
```

<h4>Example:</h4>
```java
@Inject
EbeanServer server;
...

  // find orders for a customer
  // shipped since last week
  List<Order> orders =
       server.find(Order.class)
       .where()
         .eq("customer.id", customerId)   // eq = equal to
         .gt("shipDate", lastWeek)        // gt = greater than
       .findList();

```

<h4>Example:</h4>
```java
  // find new customers with a name like rob%
  // .. only fetch their name and status
  List<Customer> customers =
      server.find(Customer.class)
       // just fetch the properties you need
      .select("name, status")
      .where()
        .eq("status", Status.NEW)
        .ilike("name", "rob%")
      .orderBy("name")
      .findList();


```

<#-------------------------------------------------------------------------------------------------->
<h2 id="intro_save_and_delete">Save and delete</h2>
<p>
Ebean is architected to make insert, update, delete simple to use and understand.
</p>


<h4>Example insert:</h4>
```java
@Inject
EbeanServer server;
...

  Customer customer = new Customer();
  customer.setName("Rob");
  customer.setStatus(Status.NEW);

  // inserts the customer
  server.save(customer);

```


<h4>Example update/delete:</h4>
```java
@Inject
EbeanServer server;
...

  Customer customer = server.find(Customer.class, customerId);
  customer.setName("Person formally known as Rob");

  // update
  server.save(customer);

  // delete
  server.delete(customer);

```

<#-------------------------------------------------------------------------------------------------->
<h2 id="jpa_comparison">Comparison to JPA</h2>

<h4>Dirty state on the bean</h4>
<p>
  The core architectural difference is that Ebean stores the 'dirty state' on
  the bean itself. All knowledge required to persist a bean is on the bean itself and beans
  are explicited saved or deleted.
</p>
<p>
  With Hibernate the Session holds the 'original state' and this along with the bean are used to
  persist the beans. Beans need to be 'attached' to the Session in order to persist them.
</p>
<p class="bs-callout bs-callout-info">
    This architectural difference means that there is no EntityManager with the associated bean lifecycle
    and flush mechanism. This is what makes Ebean easier to use and understand.
</p>

<h4>Lifecycle - EntityManager</h4>
<p>
  With Hibernate, JPA and JDO the beans have a lifecycle where the beans are attached/detached/merged/flushed
  using a JPA EntityManager (and similarly with JDO PersistenceManager).
  Developers need to be aware of this lifecycle and now not only have to manage
  the DB Transaction demarcation but they additionally have to manage the JPA EntityManager (or JDO PersistenceManager).
  Some containers and frameworks provide assistence to developers to help manage the EntityManager like 'Transaction scoped Persistence Context'
  but architecturally with JPA and JDO there are 2 things demarcate/scope. When developers want to use
  multiple transactions with the same persistence context and have to deal with the failure cases they now
  need to have a good understanding of the underlying EntityManager/Session and throw it away or ponder what
  is needed to make the EntityManager/Session usable.
</p>
<p class="bs-callout bs-callout-info">
  With Ebean you only need to demarcate/scope the transaction - no EntityManager/Session to manage.
</p>

<h4>Explicit save rather than flush</h4>
<p>
  With Ebean the developer explicitly controls which beans are persisted. With JPA/JDO you don't have that
    control and instead use flush() and the dirty beans that are 'attached' to the Session/EntityManager are persisted.
    When the EntityManager is used by various blocks of code it is not always obvious what beans will be included in the flush() - an
    attached bean might have subtly been made dirty or an additional dirty bean attached. This lack of explicit
    control can make these issues occur and are not always easy to resolve.
</p>
<p class="bs-callout bs-callout-info">
  With Ebean the developer explicitly controls which beans are persisted.
</p>

<h4>Partial Objects</h4>
<p>
  Back in 1995 I worked for Oracle Tech Support and was a trained Oracle DBA. If your query (or part of
  the query execution) could be resolved by just hitting 'index blocks' and didn't have to read 'data blocks'
  that was great for performance. Any decent ORM query language almost 20 years later would surely support
  the ability to only select the properties you need in order to support this fundamental performance
  optimisation?
</p>
<p class="bs-callout bs-callout-info">
  Ebean makes partial object queries easy.
</p>
<p>
  JPA has added 'FetchGroups' to support Partial Objects but to me it is not easy to use and should instead
  have become part of the query language.
</p>
<p>
  It is unsurprising that DBA's and SQL orientated developers have looked at the SQL that their ORM
  has generated and had a feeling of disappointment and maybe even dispair. I suspect there wasn't
  a DBA in the room when JPQL was designed or perhaps they didn't get a strong vote.
</p>
<p>
  Ebean's query language has be designed from the perspective of making is easy to specify the parts
    of the object graph you wish to fetch (Partial Objects). Additionally Ebean has made it easier
    to use by automatically determining the joins that are required to support the select, where and
    order by.
</p>

<h4>Autofetch - Query optimisation</h4>
<p>
  The extension to supporting 'Partial Objects' is to provide a mechanism that profiles what parts of
    the object graph are used for any given query. This profiling information can then be used to
    actively tune the query or provide performance improvement suggestions.
</p>

<h4>Raw SQL</h4>
<p>
  ORM's do some SQL generation well but there are many things that you can do with SQL that are <em>not</em>
    a natural fit for an ORM especially around aggregation, reporting and bulk updates. With Ebean the expectation
    is that developers will use raw SQL building some object graphs as well as for bulk updates. Ebean does
    have quite a nice wide sweet spot with it's great support for Partial Objects but it is never
    going to exhaustively support all the capabilities in SQL.
</p>
<p>
  With Ebean using raw SQL is well supported and beans any beans loaded via RawSql are fully functional with
    further lazy loading, query joins, insert, update and delete all supported.
</p>
<p>
  Bulk updates should not be shunned or avoided - some problems are much more effeciently solved by using a 'relational approach'
    and perhaps an issue when developing with an ORM is to forget to consider 'relational approaches' and especially bulk update.
</p>

<h2 id="ebean_does_not">Ebean does not...</h2>
<p>...(under construction)... list any missing features</a>

<p>Ebean supports JPA annotations, not JPA2.</p>

<p>Ebean does not provide functionality to DDl that can be used to update an existing database. Ebean does generate DDL that lets you drop and recreate your tables.
  There are a few database schema evolution tools such as <a href="http://flywaydb.org/">Flyway</a> and <a href="http://www.liquibase.org/">Liquibase</a></p>


</div>
</div> <#-- ./row -->

</div>
