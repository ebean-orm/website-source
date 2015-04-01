<div class="bs-docs-section">
<h1 id="language_support" class="page-header">Language Support</h1>


<#-------------------------------------------------------------------------------------------------->
<h2 id="groovy">Groovy</h2>
<p>You can use Ebean with Groovy classes. There is nothing special you need to do. Just
annotate your groovy beans with the JPA annotations.


```groovy
//GROOVY CODE (generates the getters and setters etc)
package test
import javax.persistence.*;

@Entity
@Table(name="f_forum")
public class PersonG{
  @Id
  Integer id

  @Column(name="title")
  String name

  @OneToMany(cascade=CascadeType.ALL)
  List<Topic> topics;
  }
```

You can use Ebean just as you would in Java.

```groovy
// GROOVY CODE
package test

import com.avaje.ebean.*

public class MainEbean{
  public static void main(String[] args) {

    PersonG g = Ebean.getReference(PersonG.class, 1);

    String name = g.getName();

    List<PersonG> list = Ebean
      .find(PersonG.class)
      .fetch("topics")
      .findList()

    println "Got list "+list

    list.each() {
      print " $\{it.id} $\{it.name} \n"
      print " GOT DETAILS: "+it.topics
    };

    println "done";
  }
}
```
</p>
<p>
Note that if you want more groovy integration please make some suggestions of what you
would like to see.</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="scala">Scala</h2>
<p>You can use Ebean with Scala as well. Again, annotate your scala “bean” with the JPA
annotations as you would normally.</p>

<p>Ebean has support for Scala 2.8 mutable Buffer, Set and Map and Option types.
(you do not have to use the Java collection types).</p>

</div>
