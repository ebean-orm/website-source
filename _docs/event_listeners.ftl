<div class="bs-docs-section">
<h1 id="event_listeners">Event listeners</h1>
...(under construction)...

<p>Since version 4.0.1, Ebean supports JPA EntityListener Annotations:
  <ul>
    <li>@PostLoad</li>
    <li>@PostPersist</li>
    <li>@PostRemove</li>
    <li>@PostUpdate</li>
    <li>@PrePersist</li>
    <li>@PreRemove</li>
    <li>@PreUpdate</li>
  </ul>

```java
import javax.persistence.PostLoad;
import javax.persistence.PostPersist;
import javax.persistence.PostRemove;
import javax.persistence.PostUpdate;
import javax.persistence.PrePersist;
import javax.persistence.PreRemove;
import javax.persistence.PreUpdate;

...

@Entity
public class Customer {

  @Id
  Long id;

  String name;

  @Version
  Long version;


  @PrePersist
  public void prePersist1() {
      ...
  }


  @PostPersist
  public void postPersist1() {
    ...
  }


  @PreUpdate
  public void preUpdate1() {
    ...
  }

  @PostUpdate
  public void postUpdate1() {
    ...
  }


  @PreRemove
  public void preRemove1() {
    ...
  }

  @PostRemove
  public void postRemove1() {
    ...
  }

  @PostLoad
  public void postLoad1() {
    ...
  }

```

<h4>BeanPersistController</h4>
<p>To listen for events on entity, you can also use the BeanPersistController</p>

<p>BeanPersistController is used to enhance or override the default bean persistence mechanism.</p>

<p>Note that if want to totally change the finding, you need to use a BeanQueryAdapter rather than using postLoad().</p>

<p>Note that getTransaction() on the PersistRequest returns the transaction used for the insert, update, delete or fetch. To explicitly use this same transaction you should use this transaction via methods on EbeanServer.</p>

```java
Object extaBeanToSave = ...;
Transaction t = request.getTransaction();
EbeanServer server = request.getEbeanServer();
server.save(extraBeanToSave, t);
```

<p>It is worth noting that BeanPersistListener is different in three main ways from BeanPersistController postXXX methods.</p>

<p>BeanPersistListener only sees successfully committed events. BeanController pre and post methods occur before the commit or a rollback and will see events that are later rolled back</p>

<p>BeanPersistListener runs in a background thread and will not effect the response time of the actual persist where as BeanController code will
BeanPersistListener can be notified of events from other servers in a cluster.</p>

<p>A BeanPersistController is either found automatically via class path search or can be added programmatically via ServerConfiguration.addEntity().</p>



</div>
