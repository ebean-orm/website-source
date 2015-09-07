<div class="bs-docs-section">
<h1 id="readaudit">@ReadAudit</h1>

  <h3>Overview</h3>
<p>
ReadAudit is a feature where read access is logged for auditing purposes. You can annotation entity
  beans with @ReadAudit and then read events on these beans (queries and hits in L2 cache) are logged.
</p>
<p>
An implementation of the ReadAuditPrepare interface is typically required. The readAuditPrepare.prepare()
  method is expected to populate the ReadEvent with user context information (user id, user ip address etc).
</p>
  <h3>Caveats</h3>
  <p>
    SqlQuery queries are currently not logged to the read audit log (RawSql queries are included in read auditing).
  </p>

  <h3>Steps - Getting started</h3>
<ul>
  <li>1) Add @ReadAudit annotation to all the entity beans that should have read auditing</li>
  <li>2) Create an implementation of ReadAuditPrepare</li>
  <li>3) Register the implementation of ReadAuditPrepare with ServerConfig</li>
  <li>4) Configure logging (logback etc) as desired. Typically read auditing is directed into it's own logs</li>
</ul>

  <h4>Step 1: Add @ReadAudit</h4>
  <p>
    Add @ReadAudit annotation to all the entity beans that should have read auditing.
  </p>
```java

  @ReadAudit
  @Entity
  @Table(name = "customer")
  public class Customer {
    ...

```
  <h4>Step 2: Implement ReadAuditPrepare</h4>
  <p>
    If you skip this step and don't supply a ReadAuditPrepare implementation a 'no op' implementation
    is used and the user context information (user id, user ip address etc) is left unpopulated.
  </p>

```java
  class MyReadAuditPrepare implements ReadAuditPrepare {

    @Override
    public void prepare(ReadEvent event) {

      // get user context information typically from a
      // ThreadLocal or similar mechanism

      String currentUserId = ...;
      event.setUserId(currentUserId);

      String userIpAddress = ...;
      event.setUserIpAddress(userIpAddress);

      event.setSource("myApplicationName");

      // add arbitrary user context information to the
      // userContext map
      event.getUserContext().put("some", "thing");
    }
  }
```

  <h4>Step 3: Register ReadAuditPrepare implementation</h4>
  <p>
    The implementation of ReadAuditPrepare can be automatically detected
    if classpath scanning is on (just like entity beans are found etc). That is,
    if scanning is on you don't need to explicitly register the ReadAuditPrepare implementation
    and instead it will be found and instantiated.
  </p>
  <p>
    If scanning is not used or the ReadAuditPrepare implementation has dependencies and its
    instantiation should be performed externally to Ebean then you can register it explicitly
    with the ServerConfig.
  </p>

```java

  // example code explicitly registering the ReadAuditPrepare implementation

  MyReadAuditPrepare readAuditPrepare = ...;

  ServerConfig config = new ServerConfig();
  config.setName("h2");
  ...
  // register explicitly here
  config.setReadAuditPrepare(readAuditPrepare);


  EbeanServer server = EbeanServerFactory.create(config);
  ...

```

</div>
