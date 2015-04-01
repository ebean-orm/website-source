<div class="bs-docs-section">
<h1 id="architecture">Architecture</h1>


<h2 id="persistence_context">Persistence context</h1>

<p>Although Ebean doesn't have an "Entity Manager" it does have a "persistence context". In
fact, you could go as far to say that any ORM worth using needs a "persistence context".</p>

<h4>Definition</h4>
<p>JPA v1.0 specification - section 5.1</p>
<p>"A persistence context is a set of managed entity instances in which for any persistent entity identity
there is a unique entity instance. Within the persistence context, the entity instances and their
lifecycle are managed by the entity manager."</p>

<p>Ebean has a "Persistence Context" to ensure ... unique entity instances BUT Ebean has a
different approach to lifecycle management.</p>

<p>That is, Ebean has a persistence context to ensure "... unique entity instance." (the blue
section of JPA's definition) but has a different approach to the lifecycle management
compared with JPA. Ebean has no entity manager and no persist/merge/flush lifecycle
methods.</p>


<h4>Unique Entity Instances</h4>
<p>Ebean uses the "persistence context" for queries and lazy loading (when it is building object
graphs). The purpose of this is to ensure that 'consistent' object graphs are constructed (1
unique instance per identity).</p>

<p>For example, in fetching a list of orders and their customers … the persistence context
ensures that you only get 1 customer instance for it's given id (e.g. you are NOT allowed to
have 2 or more instances of "customer id=7".</p>

<p>You could even say that any ORM worth using needs a persistence context when it builds
object graphs from relational result sets due to the nature of relational result sets.</p>

<p>For example, if you didn't have a persistence context and did allow 2 or more instances of
"customer 7" … and modified one instance but not the other … things get very ugly. The
"persistence context" ensures the user/application code works with unique entity instances.</p>

<h4>Lifecycle Management</h4>
<p>Ebean has a different approach to lifecycle management. The core difference is that with
Ebean each bean itself has it's own dirty checking (detects when it has been modified and
holds it's old/original values for optimistic concurrency checking).
</p>
<p>With JPA implementations generally the dirty checking is performed by the entity manager.
The entity manager generally holds the old/original values for optimistic concurrency
checking and the beans need to be 'attached' to an entity manager to be 'flushed' (as an
insert/update/delete). [Note: JDO based JPA implementations do this a bit differently].
</p>

<p>
Pro's for Ebean's approach
<ul>
  <li>No need to manage Entity Manager's</li>
  <li>save/delete simpler that attached/detached beans with persist/merge/flush etc</li>
</ul>

Con's for Ebean's approach
<ul>
  <li>Ebean makes an assumption that scalar types are immutable. Most scalar types (String, Integer, Double, Float, BigDecimal etc) are immutable, however, some such as java.util.Date are not. What this means is that with Ebean if you mutate a java.util.Date Ebean will NOT detect the change – instead you have to set a different java.util.Date instance.</li>
</ul>
</p>

<h4>Transaction scoped</h4>
<p>With Ebean the persistence context is transaction scoped. This means that when you begin
a new transaction (implicitly or explicitly) Ebean will start a new persistence context.</p>

<p>The persistence context uses weak references and lives beyond the end of a transaction. This enables any lazy loading occuring after the transaction ends to use the same persistence context that the instance was created with.
</p>
<p>
This means, a persistence context
<ul>
  <li>Starts when a transaction starts</li>
  <li>Is used during the transactions scope to build all object graphs (queries)</li>
  <li>Lives beyond the end of a transaction so that all lazy loading occuring on that object graph also uses the same persistence context</li>
</ul>
</p>


<h4>Multi-threaded object graph construction</h4>
<p>The persistence context is designed/implemented to be thread safe. Ebean internally can use multiple threads for object graph construction (query execution). Some advanced users may take an interest in this (and may want to do this in their own application code).</p>

<p> When Ebean uses background threads for fetching (findFutureList, PagingList, useBackgroundFetchAfter etc) Ebean will automatically propagate the persistence context. In these cases multiple threads can be using the same persistence context concurrently. This also enables Ebean to provide more advanced multi-threaded query strategies in the future.</p>


<h4>Persistence Context as a "first level cache"</h4>
<p>The persistence context is sometimes described as the "first level cache". I have also seen
it described as the "transactional cache" in that it is scoped to a transaction or longer.</p>

```java
// a new persistence context started with the transaction
Ebean.beginTransaction();
try {
  // find "order 72" results in that instance being put
  // into the persistence context
  Order order = Ebean.find(Order.class, 72);

  // finds an existing "order 72" in the persistence context
  // ... so just returns that instance
  Order o2 = Ebean.find(Order.class, 72);
  Order o3 = Ebean.getReference(Order.class, 72);

  // all the same instance
  Assert.assertTrue(order == o2);
  Assert.assertTrue(order == o3);
} finally {
  Ebean.endTransaction();
}
```
<p>
The code above shows that there is only 1 instance of "Order 72". As we try to fetch it
again (during the scope of a single persistence context) we end up getting back the same
instance.</p>
<p>
However, typically you don't write code that fetches the same Order multiple times in a
single transaction. The code above is not something you would typically write.</p>

<p>
A more realistic example would be when the persistence context is used:

```java
// a new persistence context started with the transaction
Ebean.beginTransaction();

try {
  // find "customer 1" results in this instance being
  // put into the persistence context
  Customer customer = Ebean.find(Customer.class, 1);
  // for this example … "customer 1" placed "order 72"
  // when "order 72" is fetched/built it has a foreign
  // key value customer_id = 1...
  // As customer 1 is already in the persistence context
  // this same instance of customer 1 is used
  Order order = Ebean.find(Order.class, 72);
  Customer customerB = order.getCustomer();
  // they are the same instance
  Assert.assertTrue(customer == customerB);
} finally {
  Ebean.endTransaction();
}
```
</p>

<p>From these examples you should hopefully see that the persistence context acts as a
cache to some degree. It can sometimes reduce the number of database queries required
when you get object graphs and navigate them.</p>

<p>However, the primary function of the persistence context is to ensure ... unique instances
for a given identity (so that the object graphs are constructed in a consistent manor). The
fact that it sometimes looks/acts like a cache is more of a side effect.</p>


<h2 id="internals">Internals</h1>
<p>
  The 4.0.1 release changed enhancement and how each bean knows which properties are loaded/changed. This is now held in a boolean. This change effected pretty much every part of the internals (lots of work) but has simplified a lot of those internals as the bean itself does the work of knowing what is loaded. It also has the effect of making embedded beans much better and paves the way for some JPA2 features for embedded beans like collections off embedded beans.
</p>

</div>
