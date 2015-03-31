<div class="bs-docs-section">
<h1 id="ebean_access_patterns">Ebean access patterns</h1>

<div class="row icon-info">
<div class="col-md-12">

<h2 id="dependency_injection">Dependency Injection</h2>
<p>
In this style Spring or Guice etc is used to inject an EbeanServer into your service objects.
Use a Spring FactoryBean or similar to create a EbeanServer instance in the DI context.
</p>

<h4>ServerConfig and EbeanServerFactory</h4>
<p>
You can programmatically create an EbeanServer instance using <code>ServerConfig</code> and <code>EbeanServerFactory</code>.

</p>

```java

  /**
   * Example creating a EbeanServer instance programmatically using
   * ServerConfig and EbeanServerFactory.
   */
  private EbeanServer createEbeanServer() {

    ServerConfig c = new ServerConfig();
    c.setName("pgtest");

    // programmatically configure a DataSource
    DataSourceConfig postgresDb = new DataSourceConfig();
    postgresDb.setDriver("org.postgresql.Driver");
    postgresDb.setUsername("test");
    postgresDb.setPassword("test");
    postgresDb.setUrl("jdbc:postgresql://127.0.0.1:5432/test");
    postgresDb.setHeartbeatSql("select count(*) from t_one");

    // load some configuration from ebean.properties
    c.loadFromProperties();

    // set some configuration
    c.setDdlGenerate(true);
    c.setDdlRun(true);
    c.setDefaultServer(false);
    c.setRegister(false);
    c.setDataSourceConfig(postgresDb);
    c.setDatabasePlatform(new PostgresPlatform());

    // explicitly register entity beans, listeners, adpaters etc
    c.addClass(Customer.class);
    c.addClass(Contact.class);

    // create the EbeanServer instance
    return EbeanServerFactory.create(c);
  }
```

<h4>Example - Spring FactoryBean</h4>
<p>
You can write your own Spring FactoryBean like below:
</p>
```java
/**
 * Simple Spring bean factory for creating the EbeanServer (Database access).
 */
public class MyEbeanServerFactory implements FactoryBean<EbeanServer> {


  public EbeanServer getObject() throws Exception {

    return createEbeanServer();
  }

  public Class<?> getObjectType() {
    return EbeanServer.class;
  }

  public boolean isSingleton() {
    return true;
  }

  /**
   * Create a EbeanServer instance.
   */
  private EbeanServer createEbeanServer() {

    // programmatically create a EbeanServer instance
    ...
  }
}

```
<h4>Ebean Spring</h4>
<p>
Alternatively you can use the avaje-ebeanorm-spring.  TODO: more info here
</p>


<h4>Example - Typical @Inject use</h4>
<p>
In your service objects you <code>@Inject</code> or <code>@Autowire</code> a EbeanServer instance.
</p>
```java
...
public class MyService {

  final EbeanServer ebeanServer;

  /**
   * Constructor injection example ...
   */
  @Inject
  public MyService(EbeanServer ebeanServer) {
    this.ebeanServer = ebeanServer;
  }

  /**
   * Some example ... using the EbeanServer instance.
   */
  public void processOrders(Date since) {

    // fetch ...
    List<Order> newOrders = ebeanServer.find(Order.class)
       .where()
         .eq("status", Order.Status.NEW)
         .gt("orderDate", since)
       .findList();

    ...

    // save ...
    ebeanServer.save(order);

  }

}
```

<hr/>
<h2 id="play_active_record">Active Record</h2>

<p>
When you create your entity beans extend the Model object and add a Finder. When your entity beans extend the Model object they
inherit some convenience methods save(), delete() etc. Adding a Finder as a public static field provides a nice way to get
query functionality.
</p>


<p>
  Use the Model MappedSuperclass to add insert(), update(), delete() etc convenience methods to your entity beans.
  This results in a clean programming style made popular by use in the Play framework. The Model and Finder objects
  have now been incorporated into Ebean to support this programming style.
</p>

<h4>Extend Model, add Finder:</h4>
```java
/**
 * Extend Model to get the save(), delete() etc
 * methods on the bean itself (active record style).
 */
@Entity
@Table(name="be_customer")
public class Customer extends Model {

  /**
   * Finder uses the 'default' EbeanServer.
   */
  public static Finder<Long,Customer> find = new Finder<Long,Customer>(Long.class, Customer.class);

  @Id
  Long id;

  String name;

  Date registered;

  String comments;

  ...

```
<p>
NOTE: Model is annotated with JPA @MappedSuperclass.  It internally makes use of the Ebean singleton in order to
provide the save, delete etc methods. View the source code for <a href='https://github.com/ebean-orm/avaje-ebeanorm/blob/play/src/main/java/com/avaje/ebean/Model.java'>Model here</a>.
<p>


<h4>Example: save</h4>
```java
    Customer customer = new Customer();
    customer.setName("Rob");

    customer.save();
```

<h4>Example: find.byId</h4>
```java
    Customer customer = Customer.find.byId(customer.getId());
```

<h4>Example: find.where</h4>
```java
    List<Customer> customers =
        Customer.find.
          where().ilike("name", "rob%")
          .findList();
```


<hr/>
<h2 id="ebean_singleton">Ebean singleton</h2>
<p>
Use the Ebean singleton object. Similar to the Play / Active record style but you don't use the Ebean specific
Model and Finder objects in your model.
</p>
<p>
The core API is provided by <code>EbeanServer</code>.  The <code>Ebean</code> singleton provides a convienience for using the 'default' or 'primary'
EbeanServer.
</p>
<p>
A <code>ebean.properties</code> file is used to control how the EbeanServer instance is configured.
</p>

<h4>Example:</h4>
```java
// get the 'default' or 'primary' EbeanServer instance
EbeanServer defaultServer = Ebean.getServer(null);


// get an EbeanServer instance that uses a different database
EbeanServer defaultServer = Ebean.getServer("humanresources");

```

<p>
The Ebean singleton provides convienience methods:
</p>

<h4>Example:</h4>
```java
Ebean.save(customer);

// is the same as ...

EbeanServer defaultServer = Ebean.getServer(null);
defaultServer.save(customer);
```


</div>
</div> <!-- ./row -->

</div>
