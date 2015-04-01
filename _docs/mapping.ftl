<div class="bs-docs-section">
<h1 id="mapping">Mapping</h1>

<p>The main goal of "Mapping" is to isolate the application code from the Database Schema.</p>
<p>This means that some changes can occur to the schema without breaking the application.
The application code can be written without reference to the specific table names, view
names and column names. This means that your application can more easily withstand
some unforseen changes.</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="jpa_mapping">JPA mapping</h2>
<p>Ebean uses the same mapping as per the JPA specification. You can learn and use the
same mapping annotations. This is generally a very good part of the specification and I'd
expect this part of the specification to mostly stand the test of time.</p>


<#-------------------------------------------------------------------------------------------------->
<h2 id="ddl_generation">DDL generation</h2>
<p>Ebean generated DDL is useful for agile development and testing. It is also useful to help get an understanding of the mapping.</p>
<p>
For simple Databases the DDL generated will be sufficient but for large databases it is not
really 'production quality'. For large Databases you will likely use it as a starting point.
DBA's will want to add more control over physical aspects of Tables and Indexes (specify
tablespaces etc to spread IO across disks, partition large tables, control freespace
depending on the etc).
</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="naming_convention">Naming convention</h2>

<p>Ebean has a Naming Convention API to map column names to property names. It also
maps entity to table names and can take into account database schema and catalog if
required.</p>

<p>Refer to: com.avaje.ebean.config.NamingConvention</p>
<p>The default UnderscoreNamingConvention converts column names with underscores into
normal java camel case property names (e.g. "first_name" maps to "firstName").</p>


<p>You can also use the MatchingNamingConvention or implement your own.</p>

<p>The MatchingNamingConvention names column names to match property names and table names to match entity names.
  Ebean follows the JPA specification which states that the in the case of no annotations the name of the class will be take as the table name and the name of a property will be taken as the name of the column.
</p>

<h2 id="mapping_annotations">Mapping annotations</h2>

<h4>Basics</h4>
<ul>
  <li>
    @Entity - This simply marks an Entity Bean. Ebean has the same restrictions as per the JPA spec
    with the entity beans requiring a default constructor and with properties following the java
    beans conventions (with getter and setter names).
  </li><li>
    @Table - Here you can specify the table name that the entity bean will use. More specifically this is
    the "base table" as an entity bean could have a number of "secondary" tables as well.
  </li><li>
    @Id and @EmbeddedId -Use one of these to mark the property that is the id property. You should use @Id if the id
    property is a simple scalar type (like Integer, String etc) and you should use @EmbeddedId if the id type is complex (an embedded bean).
  </li><li>
    @Column - Use this if the naming convention does not match the bean property name to the database
    column or if you need to use quoted identifiers. Otherwise it is not required.
  </li><li>
    @Lob - This marks a property that is mapped to a Clob/Blob/Longvarchar or Longvarbinary.
  </li><li>
    @Transient -This marks a property that is not persistent.
  </li><li>
    @CreatedTimestamp - Sets a timestamp property to current datetie when the entity is created/inserted. An alternative to using this annotation would be to use @Column(insertable = false, updateable = false) and then have the DB insert the current time (set the default value on the DB column is SYSTIME etc).  The downside to this alternative approach is that the inserted entity does not have the timestamp value after the insert has occurred. You need to fetch the entity back to get the inserted timestamp if you want to used it.
    <br>
    @UpdatedTimestamp - Set a timestamp property that is set to the datetime when the entity was last updated.

  </li>


</ul>


<#-------------------------------------------------------------------------------------------------->
<h2 id="relationships">Relationships</h2>

<h4>Database Design and Normalisation</h4>
<p>If you are familiar with Database design and normalisation then the relationships
will become clear fairly quickly. If you are not familiar then it is recommended that you read up on these
topics (a quick trip to wikipedia) since it will help you a lot in this area of ORM mapping.
</p>

<h4>DB Foreign Keys and ORM Relationships</h4>
<p>Assuming your DB has foreign keys and has been well designed then the ORM mapping
should follow quite naturally. If you DB has a more "interesting" design then the ORM
mapping can be a lot more painful with more compromises.</p>

<h4>One-to-Many relationship</h4>
<p>This is probably the most common relationship so we will start with a One to Many
relationship. The @OneToMany and the @ManyToOne represent the two ends of a
relationship. This relationship typically maps directly to a Database Foreign Key
constraint...</p>

<h4>Database Foreign Key constraint</h4>
<p>A typical database design is full of "One to Many/Many to One" relationships implemented
using a Foreign Key constraint. A foreign key constraint has an "imported" side and an
"exported" side.</p>
<ul>
  <li>"A Customer has many Orders"</li>
  <li>"An Order belongs to a Customer"<li>
  <li>The customer table "exports" its primary key to the order table</li>
  <li>The order table "imports/references" the customer table's primary key.</li>
</ul>

<div class="bs-callout bs-callout-primary">
<p>  A Foreign Key constraint can be viewed from the exported side
(customer table) or the imported side (order table).</p>
<p>... @OneToMany and @ManyToOne map directly to this.</p>
</div>

<p>
The Customer entity bean...
```java
...
@Entity
@Table(name="or_customer")
public class Customer {
  ...
  @OneToMany
  List<Order> orders;
```

The Order entity bean...
```
...
@Entity
@Table(name="or_order")
public class Order {
  ...
  @ManyToOne
  Customer customer;
```
</p>
<p>
Because the @OneToMany and @ManyToOne are both mapped this is a
"Bidirectional" relationship. You can navigate the object graph in either
direction.
</p>

<h4>Unidirectional Relationships</h4>
<p>To turn a Bidirectional relationship into a Unidirectional relationship you need to either
remove the @OneToMany (Customer.orders property) or the @ManyToOne (Order.customer property).</p>

<h4>Removing a OneToMany - no problem</h4>
<p>eg. Remove List<Order> from Customer
</p><p>
You can generally remove the OneToMany side of a relationship without any major issues.
The issue being that you can not navigate the object graph in that direction.
</p><p>
Why remove a OneToMany? Sometimes the OneToMany side is not useful to the
application or even dangerous if used. For example on Product there could be a
List<OrderDetail> but that could be considered useless or even dangerous if it was
navigated (and all order details for a product where lazy loaded).

<h4>Removing a ManyToOne - watch those inserts...</h4>
<p>eg. Remove Customer from Order
</p><p>
If you remove a ManyToOne this effects how a bean is saved (specifically the insert). The
reason is because it is the ManyToOne (importing) side of the relationship that holds the
foreign key column (e.g. or_order table holds the customer_id foreign key column).
</p><p>
Q: If the customer property is removed from the Order object how would you specify
which customer placed an order when you create a new order?
In Database speak this translates to ... when inserting an order how is the customer_id
column populated?
</p><p>
A: You have to use cascading save on the customer.orders and save the customer.
Sounds like a pain... and it would be in this case... lets look at a more realistic case where
you want to remove a ManyToOne...
</p><p>
eg. Remove Order from OrderDetail
</p><p>
Lets say you remove the Order property from the OrderDetail bean. Now lets say you
want to write some code to add a OrderDetail to an Order (insert). How do you specify
which Order it should go to?
</p><p>
"Turn on" cascade save on the @OneToMany side
```java
@Entity
@Table(name="or_order")
public class Order {
  ...
  // must cascade the save
  @OneToMany(cascade=CascadeType.ALL)
  List<OrderDetail> details;
```

And save the order... which cascade saves the details
```java
// create or fetch the order
Order order = ...
List<OrderDetail> details = new ArrayList<OrderDetail>();
OrderDetail orderDetail = ...
details.add(orderDetail);

// set the new details...
order.setDetails(details);

// save the order... which cascade saves
// the order details...
Ebean.save(order);
```
</p><p>
So when the order is saved, because the @OneToMany relationship has cascade.ALL
the save is cascaded to all the order details.
</p><p>
Note that you can update OrderDetails individually (without relying on cascade save) but
to insert a new OrderDetail we are relying on the cascading save.
<div class="bs-callout bs-callout-primary">
<p>Removing a ManyToOne typically reflects a strong "ownership"
relationship. The Order "owns" the OrderDetails, they are persisted as
one via cascade save.</p>
</div>

<h4>Managed Relationships = @OneToMany + cascade save</h4>
<p>
If cascade save is on a @OneToMany when the save is cascaded down from the 'master'
to the 'details' Ebean will 'manage' the relationship.
</p><p>
For example, with the Order - OrderDetails relationship when you save the order Ebean
will get the order id and make sure it is 'set' on all the order details. Ebean does this for
both Bidirectional relationships and Unidirectional relationships.
</p><p>
What this means is that if your OrderDetails has an @ManyToOne Order property (its
bidirectional) you do not need to set the order against each orderDetail when you use
cascade save. Ebean will automatically set the 'master' order to each of the details when
you save the Order and that cascades down to the details.
</p>
<h4>@OneToMany Notes</h4>
<p>
When you assign a @OneToMany you typically specify a mappedBy attribute. This is for
Bi-directional relationships and in this case the "join" information is read from the other
side of the relationship (meaning you don't specify any @JoinColumn etc on this side).
</p><p>
If you don't have a mappedBy attribute (there is no matching property on the other related
bean) then this is a Unidirectional relationship. In this case you can specify a
```java
@JoinColumn if you wish to override the join column information from the default).
@Entity
@Table(name="s_user")
public class User implements Serializable {

  // unidirectional …
  // … can explicitly specify the join column if needed
  @OneToMany
  @JoinColumn(name="pref_id")
  List<Preference> preferences;

  // bi-directional
  // … join information always read from the other side
  @OneToMany(mappedBy="userLogged")
  List<Bug> loggedBugs;
```

<h4>One-to-One relationship</h4>
<p>
A One-to-One relationship is exactly the same as a One-to-Many relationship except that
the many side is limited to a maximum of one.
</p><p>
That means that one of the @OneToOne sides operates just like a @ManyToOne (the
imported side with the foreign key column) and the other @OneToOne operates just like a
@OneToMany (exported side).
</p><p>
So you put the mappedBy on the 'exported side' – as if it was a @OneToMany.
</p><p>
From a Database perspective a One to One relationship is implemented with a foreign key
constraint (like one to many) and adding a unique constraint on the foreign key column.
This has the effect of limiting the "many" side to a maximum of one (has to be unique).

<h4>Many-to-Many relationship</h4>
<p>
You are probably aware that there are no Many to Many relationships in a physical
database design. These are implemented with an intersection table and two One to Many
relationships.
</p><p>
Lets look at an example...
<ul>
  <li>A User can have many Roles</li>
  <li>A Role can be assigned to many Users</li>
  <li>A Many to Many between user and role</li>
</ul>

<img src="/images/docs/A_Many_to_Many_between_user_and_role.png" class="img-responsive">

<p>
In the database diagram above there is an intersection table called s_user_role. This
represents a logical many to many relationship between user and role.
</p><p>
Q: When is a Many to Many better represented as two One to Many relationships?
</p><p>
A: If there is ever an additional column in the intersection table then you should consider
changing this from a Many to Many to two One to Many's and including the intersection
table in the model.
</p><p>

One way to think of this is that each @ManyToMany operates just like it was a
@OneToMany. The relationship must be "managed" meaning Ebean must take care of
inserting into and deleting from the intersection table.
</p><p>
The way this works is that any additions or removables from the many list/set/map are
noted. These become inserts into and deletes from the intersection table.
```java
@Entity
@Table(name="s_user")
public class User implements Serializable {
  ...
  @ManyToMany(cascade=CascadeType.ALL)
  List<Role> roles;
  @Entity
  @Table(name="s_role")
  public class Role {
  ...
  @ManyToMany(cascade=CascadeType.ALL)
  List<User> users;
```
</p><p>

The intersection table name and foreign key columns can default or be specified by @JoinTable etc.
</p><p>
The following code shows a new role added to a user.
```java
User user = Ebean.find(User.class, 1);
List<Role> roles = user.getRoles();
Role role = Ebean.find(Role.class, 27);

// adding a role to the list...this is remembered and will
// result in an insert into the intersection table
// when save cascades...
roles.add(role);

// save cascades to roles... and in this case
// results in an insert into the intersection table
Ebean.save(user);
```
</p><p>
Note that if a role was removed from the list this would result in an appropriate delete from
the intersection table.
</p>


<h2 id="id_generation">Id generation</h2>
<ul>
  <li>DB Identity / Autoincrement</li>
  <li>DB Sequences</li>
  <li>UUID</li>
  <li>Custom ID Generation</li>
</ul>

<p>There are 4 ways that ID's can be automatically generated for new Entities. This occurs
when a entity is going to be inserted and it does not already have an Id value.</p>

<p>The first 3 options are highly recommended for 2 reasons.</p>
<ol>
  <li>They are standard approaches that can also be used by other programs, stored
procedures, batch loading jobs etc that could be written in other languages etc. That is, if
you choose a custom ID Generation then this can make it more difficult to use other
programs / tools to insert into the DB.</li>
  <li>They support good concurrency – can you really do better? Most Databases support Sequences or Identity/Autoincrement. DB2 and H2 support both.</li>
</ol>

<h4>UUID Id Generation</h4>
<p>To use UUID's with Ebean all you need to do is use the UUID type for your id property.</p>
<p>Ebean will automatically assign an appropriate UUID Id generator.
```java
@Entity
public class MyEntity {
@Id
UUID id;
...
```
</p>
<h4>DB Sequences / DB Autoincrement</h4>
<p>
Refer: com.avaje.ebean.config.dbplatform.DatabasePlatform and DbIdentity
</p>
<p>
For each database type (Oracle, MySql, H2, Postgres etc) there is a specific
DatabasePlatform which defines whether the database supports sequences or
autoincrement. This then defines whether DB sequences or DB Identity / Autoincrement
will be used. This also provides a sequence generator specific to that database.
</p><p>
For DB sequences the NamingConvention is used to define the default name of the
sequences. This name will be used unless the sequence name is explicitly defined via
annotations.
</p><p>
What this means is that, typically you only need to the the @Id annotation unless you
need to override a sequence name (when it doesn't match the naming convention).
```java
@Entity
public class MyEntity {
@Id
Integer id;
...
```
</p>

<h4>Batched fetch of Db Sequences</h4>
<p>For performance reasons we don't want to fetch a sequence value each time we want an
Id. Instead we fetch a 'batch' of sequences (refer to ServerConfig
setDatabaseSequenceBatchSize() ) - the default batch size is 20.
</p><p>
Also note that when the number of available Id's for a given sequence drops to half the
batch size then another batch of sequences is fetched via a background thread.
</p><p>
For Oracle, Postgres and H2 we use Db sequences. It is worth noting that this allows the
use of JDBC batch statements (PreparedStatement.addBatch() etc) which is a significant
performance optimization. You can globally turn on the use of JDBC batching via
ServerConfig.setUsePersistBatching() … or you can turn it on for a specific Transaction.
</p>


<#-------------------------------------------------------------------------------------------------->
<h2 id="formula">@Formula</h2>

<p>
@Formula can be used to get read only values using SQL Literals, SQL Expressions and SQL Functions.
</p><p>
With a Formula the $\{ta} is a special token to represent the table alias. The table alias is
dynamically determined by Ebean and you can put the $\{ta} in the select or join attributes.
</p>
<h4>A SQL Expression</h4>
<p>
Example: The caseForm field using a SQL case expression
```java
...
@Entity
@Table(name="s_user")
public class User {
  @Id
  Integer id;

  @Formula(select="(case when $\{ta}.id > 4 then 'T' else 'F' end)")
  boolean caseForm;
  ...
```
</p><p>
Note the $\{ta} in place of the table alias
</p><p>
Note in this deployment 'T' and 'F' are mapped to boolean values.
</p>

<h4>A SQL Function</h4>
<p>
```java
@Formula(select="(select count(*) from f_topic _b where _b.user_id =$\{ta}.id)")
int countAssiged;
```
</p><p>

The formula properties can be used as normal properties. This includes in query select
and where expressions.
```java
// include the countAssigned property
Query<User> query = Ebean.createQuery(User.class);
query.select("id, name, countAssiged");
query.fetch("topics");
List<User> list = query.findList();
```
</p><p>
The SQL generated from the query above is:
```xml
<sql summary='[app.data.User]'>
select u.id, u.name,
(select count(*) from f_topic _b where _b.user_id = u.id)
from s_user u
</sql>
```
</p><p>
Note the "u" in the sql has replaced the $\{ta} [table alias placeholder] specified in the
select attribute of the formula.
</p><p>
<b>It is also worth noting that this is potentially not great SQL!!!</b> You should check SQL
in this form (get the explain plan for the query – get your DBA to review the sql etc) but
there is a good chance the sub query (select count(*) ... _b.user_id = u.id) will effectively
execute for each row returned. If that is the case the query above can quickly become
expensive and you may find you have an unhappy DBA .
</p><p>
The above can be re-written to use a view (if one exists). The benefit is that we can use a
join rather than a subquery which can perform much better from a database perspective.
```sql
// VIEW: vw_topic_aggr
// Lets say there is a view base on this SQL.
// It is typically more performant to JOIN
// to a view rather than use a subquery
create view vw_topic_aggr as
select user_id, max(id) as topic_max, count(*) as topic_count
from f_topic
group by user_id
```

And use the join attribute of @Formula

```java
@Formula(
  select="_b$\{ta}.topic_count",
  join="join vw_topic_aggr as _b$\{ta} on _b$\{ta}.user_id = id")
int countWithJoin;
```
</p><p>
Now, if the view does not exist we can do something similar ...
</p><p>
In this next @Formula the join attribute contains the select effectively replacing the
vw_topic_aggr view with (select user_id, max(id) as topic_max, count(*) as topic_count
from f_topic group by user_id).
```
@Formula(
  select="_b$\{ta}.topic_count",
  join="join (select user_id, max(id) as topic_max, count(*) as topic_count from f_topic group by user_id) as _b$\{ta} on _b$ {ta}.user_id = id")
int countWithJoin;
```
```java
Query<User> query = Ebean.createQuery(User.class);
query.select("id, name, countWithJoin");
List<User> list = query.findList();
```
</p><p>
Results in the following SQL: - will generally perform better than the subquery
```xml
<sql summary='[app.data.User]'>
select u.id, u.name, _bu.topic_count
from s_user u
join (select user_id, max(id) as topic_max, count(*) as topic_count
from f_topic group by user_id) as _bu on _bu.user_id = id
</sql>
```
</p><p>
It is also worth noting that the formula fields can be used in where expressions.
</p><p>
Example: where countWithJoin > 1
```java
Query<User> query = Ebean.createQuery(User.class);
query.select("id, name, countWithJoin");
// using the formula field in the where
query.where().gt("countWithJoin", 1);
List<User> list = query.findList();
```
Resulting SQL:
```xml
<sql summary='[app.data.User]'>
select u.id, u.name, _bu.topic_count
from s_user u
join (select user_id, max(id) as topic_max, count(*) as topic_count
from f_topic group by user_id) as _bu on _bu.user_id = id
where _bu.topic_count > ?
</sql>
```
</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="enummapping">EnumMapping</h2>
<p>
This is an Ebean specific annotation (not part of JPA) for mapping Enum's to database
values. The reason it exists is that IMO the JPA approach for mapping of Enums is highly
dangerous (in the case of Ordinal mapping) or not very practical (in the case of String
mapping).
</p><p>
Lets take the example of this Enumeration:
```java
public enum UserStatus {
  ACTIVE, INACTIVE, NEW
}
```
</p><p>
Enum Ordinal Mapping is Dangerous
</p><p>
  In my opinion JPA Ordinal Mapping for Enum's is very dangerous, and it is recommended that you avoid it.
  The reason is because the ordinal values for Enum depends on the order in which they appear.
```java
public class TestStatus {
  public static void main(String[] args) {
      int ord0 = UserStatus.ACTIVE.ordinal();
      int ord1 = UserStatus.INACTIVE.ordinal();
      int ord2 = UserStatus.NEW.ordinal();

      // 0, 1, 2
      System.out.println("ord 0:"+ord0+" 1:"+ord1+" 2:"+ord2);

      String str0 = UserStatus.ACTIVE.name();
      String str1 = UserStatus.INACTIVE.name();
      String str2 = UserStatus.NEW.name();

      // "ACTIVE", "INACTIVE", "NEW"
      System.out.println("str 0:"+str0+" 1:"+str1+" 2:"+str2);
  }
}
```
OUTPUT:
<pre>
ord 0:0 1:1 2:2
str 0:ACTIVE 1:INACTIVE 2:NEW
</pre>
</p><p>

The problem is that if you change the order of the Enum elements such as in this example
(DELETED is now first with Ordinal value of 0) ...
```java
public enum UserStatus {
  DELETED, ACTIVE, INACTIVE, NEW
}
```
</p><p>
With the above code the Ordinal values for ACTIVE, INACTIVE and NEW have all
changed. This is a very subtle change and now every status existing in the database will
be incorrectly represented in the application. Hopefully this issue would be picked up
quickly but there could be situations where this subtle data issue is not picked up before a
real disaster has occured.

<h4>Enum String mapping is limited</h4>
<p>It is more likely that your DBA would prefer to save space by mapping this to a
VARCHAR(1) column and use "A", "I", "N" and "D" as codes to represent ACTIVE,
INACTIVE, NEW and DELETED.
</p><p>
The issue with the String mapping is that more frequently than not the names of the
Enumeration elements will have to be comprimised to short less-meaningful names to
map into DB values or your DBA will be unhappy with long wasteful values.
</p>

<h4>@EnumValue</h4>
```java
public enum UserStatus {
  @EnumValue("D") DELETED,
  @EnumValue("A") ACTIVE,
  @EnumValue("I") INACTIVE,
  @EnumValue("N") NEW
}
```
<p>
With EnumValue (Ebean specific annotation) you explicitly specify the value map the entry
to. This Annotation has been logged with the Eclipselink project in the hope it makes it's
way into the JPA spec.
</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="encryption">Encryption</h2>
<h3>Transparent Encryption with Ebean</h3>
<p>
Ebean v2.4 added support for automatic Encryption/Decryption of properties.
The result is that without changing your application code some of your
properties on your entities can stored in encrypted form in the DB.
</p>

<h3>DB Encryption and "Java client Encryption"</h3>
<ul>

<li>The encryption can be performed by Database functions or on the Java side (Java client encryption).</li>
<li>
Properties that are encrypted using Database functions can be used in Query WHERE clauses.
</li>
<li>
Properties that are encrypted using "Java client Encryption" can NOT be used in Query WHERE clauses.
</li>
</ul>

<h3>DB Encryption of String and "Date" types</h3>
<p>
Currently DB Encryption for H2, Postgres, MySql and Oracle can be used on String types and "Date" types (java.sql.Date, Joda DateMidnight, Joda LocalDate).
</p>
<p>
Any type not supported by DB Encryption functions uses "Java client Encryption".
</p>


<h3>DB Encryption Functions</h3>
<p>
The default DB encryption decryption functions used are:
</p>

<ul>
<li>H2:  ENCRYPT() and DECRYPT() with 'AES' option</li>
<li>MySql: AES_ENCRYPT() and AES_DECRYPT()</li>
<li>Postgres: requires pgcryto and uses PGP_SYM_ENCRYPT() and PGP_SYN_DECRYPT()</li>
<li>Oracle: requires dbms_crypto and uses custom functions for encryption and decryption</li>
</ul>



<h3>Encryptor (Java client encryption implementation)</h3>
<p>
When Java client encryption occurs the "Encryptor" interface is used. By default Ebean has a AES 128 bit based implementation but you can also configure Ebean to use your own implementation if you wish.
</p>


<h3>EncryptKeyManager</h3>
<p>
Whenever a property is encrypted or decrypted a "Key" must be used. Ebean will internally ask the EncryptKeyManager for a key given the table and column name.
</p>
<p>
You must supply an implementation of the EncryptKeyManager.
</p>


<h3>Deployment: @Encrypted and EncryptDeployManager</h3>
<p>
You can mark a property to be Encrypted programmatically via EncryptDeployManager, or put the @Encrypted annotation on the bean property or a combination of the two.
</p>
<p>
By default a property will use DB encryption if it is supported (based on its type - String or 'Dates' basically). If you want to ensure a property uses Java encryption you can specify dbEncryption=false on the annotation or EncryptDeploy. You may want to do this so that the CPU cycles for encryption/decryption occur on the Java process rather than the DB process.
</p>
<p>

Your application code does not change
That's it.  Your code to query, insert, update and delete etc does not change and Ebean automatically does the encryption/decryption behind the scenes.
</p>

```java
// Use @Encrypted annotation to mark the encrypted properties

...
@Entity
@Table(name="pm_patient")
public class Patient {

    @Id
    Integer id;

    @Encrypted
    String name;

    // use client side encryption (not db functions)
    @Lob
    @Encrypted(dbEncryption=false)
    String description;

    @Encrypted
    Date dob;
    ...
```

<h3>Limitations</h3>
<ul>
<li>
Properties using Java client encryption can NOT be used in WHERE clauses
</li>
<li>
Only DB Encryption support built in for H2, Postgres, MySql and Oracle.
</li>
<li>
You can not use Encryption with positioned (1,2,3...) parameters. You must
use named parameters or the criteria api to define queries.
</li>
</ul>


<h3>Examples:</h3>
```
List&lt;Patient&gt; list  =
    Ebean.find(Patient.class)
        .select("id, name")
        .where().eq("name", "Rob")
        .findList();
```
<p>
Results in the following SQL:
</p>
```xml
<sql summary='Patient' >
  select e.id as c0, pgp_sym_decrypt(e.name,?) as c1
  from pm_patient e
  where pgp_sym_decrypt(e.description,?) = ?
<sql>
```


<h3>Configuraton:</h3>
<p>
You can specify the EncryptKeyManager implementation in the ebean.properties
file like below:
</p>

```properties
# ebean.properties - specify the Key Manager
ebean.encryptKeyManager=com.avaje.tests.basic.encrypt.BasicEncyptKeyManager
```
<p>
Or if you are programmatically configuring an EbeanServer using ServerConfig,
set the EncryptKeyManager.
</p>
```java
// programmatically configure an EbeanServer
// with an EncryptKeyManager

ServerConfig config = ServerConfig();
...
EncryptKeyManager keyManager = ...;
config.setEncryptKeyManager(encyptKeyManager());
...
EbeanServer server = EbeanServerFactory.create(config);
```

<h3>A EncryptKeyManager:</h3>

```java
package com.avaje.tests.basic.encrypt;

import com.avaje.ebean.config.EncryptKey;
import com.avaje.ebean.config.EncryptKeyManager;

public class BasicEncyptKeyManager implements EncryptKeyManager {

    /**
     * Initialise the key manager.
     */
    public void initialise() {
        // can load keys or initialise source resources ...
    }

    public EncryptKey getEncryptKey(String tableName, String columnName) {

        // get the key for the given table and column
        String keyValue = ...;
        return new BasicEncryptKey(keyValue);
    }

}
```

<h3>Internals</h3>
<p>
What Ebean is doing internally is detecting when an encrypted
property is being used. Internally it will call the EncryptKeyManager
with the table and column of the property to get the encryption key.
This key is then added as a bind variable to the prepared statement.
</p>
<p>
As the key is added as a bind variable into the statement you can
not use encryption with 'ordered' parameters because it can effectively
change the position of other parameters. You can use 'named'
parameters or the criteria api for building queries - but you can't
use positioned (1,2,3,4..) parameters.
</p>



</div>
