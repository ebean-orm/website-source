<div class="bs-docs-section">
<h1 id="l2caching">L2 caching</h1>

<p>
When we want to talk about caching for performance we are talking about the "Level 2"
cache or the "server cache". It is called the "Level 2 cache" because the persistence
context is often referred to as the "Level 1 cache".
</p>
<p>
The goal of the L2 server cache is to gain very significant performance improvement by
not having to hit the database.
</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="bean_and_query_caches">Bean and query caches</h2>
<p>
Ebean has 2 types of caches – Bean caches and Query caches.
</p>
<h4>Bean Caches</h4>
<p>Bean caches hold entity beans and are keyed by their Id values.</p>
<h4>Query Caches</h4>
<p>
Query caches hold the results of queries (Lists, Sets, Maps of entity beans) and are keyed
by the query hash value (effectively a hash of the query and its bind values).
The entries in a query cache are invalidated by ANY change to the underlying table –
insert, update or delete. This means that the query cache is only useful on entities that are
infrequently modified (typically "lookup tables" such as countries, currencies, status codes
etc).
</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="read_only_instances">Read only instances</h2>
<p>
For a performance optimisation when using the cache you can inform Ebean that you
want "read only" entities. If you ask for "read only" entities Ebean can give you the
instance that is in the cache rather than creating a new copy (creating a new instance and
copying the data from the cached instance).
</p>
<p>
To be safe in allowing many threads to share the same instances (from the cache) Ebean
ensures that these instances can not be mutated. It sets flags (sharedInstance=true,
readOnly=true) and any attempt to modify the entity (via setters or putfields) results in an
IllegalStateException being thrown.
</p>

```java
// Cache countries. Use readOnly=true so unless explicitly
// stated in the query we will return read only/shared instances
@CacheStrategy(readOnly=true,warmingQuery="order by name")
@Entity
@Table(name="o_country")
public class Country {
```

<p>Note that Countries is a good candidate for a default setting of readOnly=true. This is
because (for my application) country information is very rarely changed. The application
code mostly treats the countries as read only.</p>

<p>Now, whenever we get a country (via direct query or indirectly via relationships/joins) unless
we explictly say query.setReadOnly(false) we are going to get back readOnly instances that
we will not be able to mutate.</p>

```java
// we will use the cache .. and the instance
// in the cache is returned to us (not a copy)
Country country = Ebean.find(Country.class, "NZ");

// this country instance is readOnly
Assert.assertTrue(Ebean.getBeanState(country).isReadOnly());
try {
  // we can't modify a readOnly bean
  // … a IllegalStateException is thrown
  country.setName("Nu Zilund");
  Assert.assertFalse("Never get here",true);
} catch (IllegalStateException e){
  Assert.assertTrue("This is readOnly",true);
}

// explicitly state we want a MUTABLE COPY
// … not the same instance as the one in cache
// … a copy is made and returned instead
Country countryCopy = Ebean.find(Country.class)
.setReadOnly(false)
.setId("NZ")
.findUnique();

// we can mutate this one
countryCopy.setName("Nu Zilund");

// save it, automatically maintaining the cache ...
// evicting NZ from the Country bean cache and
// clearing the Country query cache
Ebean.save(countryCopy);
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="shared_instances">Shared instances</h2>
<p>Ebean sets a sharedInstance flag on a bean whenever it is put into the cache. This is
used to ensure that the bean is always treated in a read only fashion (and can be safely
shared by multiple threads concurrently).</p>

<p>
You can invoke lazy loading on a sharedInstance. When that occurs the sharedInstance
flag is propagated to the lazily loaded beans. If you lazy load a collection (list, set or map)
then the collection is also marked with the sharedInstance flag and that means you can't
add or remove elements from the collection (list, set or map).</p>

<o>
A sharedInstance and all its associated beans and collections are are all ensured to be
read only and can be safely shared by multiple threads concurrently.</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="automatic_cache_maint">Automatic Cache Maintenance</h2>
<p>When you save entity beans or use an Update or SqlUpdate, Ebean will automatically
invalidate the appropriate parts of the cache.</p>

<p>If you save a entity bean that results in an update and there is a matching bean in the
cache it will be evicted automatically from the cache at commit time.
If you save an entity bean that results in an insert then the bean cache is not effected.
Whenever ANY change is made (insert/update or delete) the entire query cache for that
bean type is invalidated.</p>


<h2 id="external_mods">Handling External Modification</h2>

<p>When you save/delete beans via Ebean.save() and Ebean.delete() etc Ebean will
automatically maintain its cache (removing cached beans and cached queries as
appropriate). However, you may often find yourself modifying the database outside of
Ebean. (via stored procedures etc)</p>


<p>For example, you could be using other frameworks, your own JDBC code, stored
procedures, batch systems etc. When you do so (and you are using Ebean caching) then
you can inform Ebean so that it invalidates appropriate parts of its cache.</p>

```java
// inform Ebean that some rows have been inserted and updated
// on the o_country table.
// … Ebean will maintain the appropriate caches.
boolean inserts = true;
boolean updates = true;
boolean deletes = false;
Ebean.externalModification("o_country", inserts, updates, deletes);

// clearAll() caches via the ServerCacheManager ...
ServerCacheManager serverCacheManager =
Ebean.getServerCacheManager();

// Clear all the caches on the default/primary EbeanServer
serverCacheManager.clearAll();

// clear both the bean and query cache
// for Country beans ...
serverCacheManager.clear(Country.class);

// Warm the cache of Country beans
Ebean.runCacheWarming(Country.class);
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="cachestrategy">@CacheStrategy</h2>

<p>CacheStrategy provides a way to automatically use the bean cache</p>

<p>The easiest way to use caching is to specify the @CacheStrategy annotation on the entity
class. This means that Ebean will try to use the bean cache as much as possible when it
fetches beans of that type.</p>

```java
// Cache countries. Use readOnly=true so unless explicitly
// stated in the query we will return read only/shared instances
@CacheStrategy(readOnly=true,warmingQuery="order by name")
@Entity
@Table(name="o_country")
public class Country {
```

```java
// automatically use the cache
Country country = Ebean.find(Country.class,"NZ");
// references automatically use the cache too
Country countryRef = Ebean.getReference(Country.class,"NZ");
// hit the country cache automatically via join
Customer customer = Ebean.find(Customer.class, 1);
Address billingAddress = customer.getBillingAddress();
Country c2 = billingAddress.getCountry();
```

<h4>ReadOnly</h4>
<p>The readOnly attribute of @CacheStrategy is used to determine if by default Ebean
should return the same instance from the cache (instances in the cache are readOnly and
effectively immutable) or whether Ebean should create a new instance and copy the data
from the cached bean onto the new instance.</p>

<p>The readOnly attribute of @CacheStrategy is the "default" Ebean will use unless you
explicitly specify the readOnly attribute of the query.</p>

```java
// explicitly state we want a MUTABLE COPY
// … not the same instance as the one in cache
// … a copy is made and returned instead
Country countryCopy = Ebean.find(Country.class)
  .setReadOnly(false)
  .setId("NZ")
  .findUnique();

// we can mutate this one
countryCopy.setName("Nu Zilund");

// save it, automatically maintaining the cache ...
// evicting NZ from the Country bean cache and
// clearing the Country query cache
Ebean.save(countryCopy);
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="manual_cache_use">Manually specifying to use the bean cache</h2>
<p>If you don't use @CacheStrategy you can programmatically specify to use the bean cache via query.setUseCache(true);</p>

```java
// explicitly state we want to use the bean cache
Customer customer = Ebean.find(Customer.class)
  .setUseCache(true)
  .setId(7)
  .findUnique();
// use readOnly=true to return the 'sharedInstance'
// from the cache (which is effectively immutable)
Customer customer = Ebean.find(Customer.class)
  .setUseCache(true)
  .setReadOnly(true)
  .setId(7)
  .findUnique();
```

<#-------------------------------------------------------------------------------------------------->
<h2 id="using_query_cache">Using the Query Cache</h2>
<p>To use the query cache you have to explicitly specify its use on a query.</p>

```java
// use the query cache
List<Country> list = Ebean.find(Country.class)
  .setUseQueryCache(true)
  .where().ilike("name", "New%")
  .findList();
```

<p>The query cache is generally useful for returning lists that are very infrequently changed. These lists would often be used to populate drop down lists / combo boxes in user
interfaces.</p>

<p>If you are familiar with the term "Lookup Tables" or "Reference Tables" these are typical candidates for using cached queries. Some examples of lookup/reference tables could be,
countries, currencies and order status.</p>

<p>Query cache lists are readOnly by default
```java
// by default the lists returned from the query
// cache are readOnly. Use setReadOnly(false) to
// return mutable lists
List<Country> list = Ebean.find(Country.class)
  .setUseQueryCache(true)
  .setReadOnly(false)
  .where().ilike("name", "New%")
  .findList();
```
</p>
</div>
