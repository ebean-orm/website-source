<div class="bs-docs-section">
<h1 id="testing">Testing</h1>

<h2 id="mockibean">MockiEbean</h2>

<code>MockiEbean</code> from <code>avaje-ebeanorm-mocker</code> project provides a helper object to support mocking the EbeanServer using tools like
<a href="http://code.google.com/p/mockito/">Mockito</a>. If you like the Play/Active record style or Ebean singleton style you can add a test
dependency on avaje-ebeanorm-mocker and use MockiEbean to enable use of Mockito and similar tools.

Mocking with Ebean singleton
<code>MockiEbean</code> from avaje-ebeanorm-mocker provides a mechanism for using a tool like Mockito and
replacing the default EbeanServer instance with a mock.
</p>

```java
...
import com.avaje.ebeaninternal.server.core.DefaultServer;
...

  @Test
  public void testWithMockito() {

    EbeanServer defaultServer = Ebean.getServer(null);
    assertTrue("is a real EbeanServer", defaultServer instanceof DefaultServer);

    Long someBeanId = Long.valueOf(47L);

    // Use Mockito to create a mock for the EbeanServer interface
    EbeanServer mock = Mockito.mock(EbeanServer.class);

    // setup some required behaviour
    when(mock.getBeanId(null)).thenReturn(someBeanId);

    // ---------------
    // 'register' the mock instance into Ebean
    // this becomes the 'default EbeanServer' until
    // mockiEbean.restoreOriginal() is called
    // ---------------
    MockiEbean mockiEbean = MockiEbean.start(mock);
    try {

      // Ebean singleton 'default server' now returns the mock instance
      EbeanServer server = Ebean.getServer(null);

      // always returns the someBeanId setup by Mockito
      Object beanId = server.getBeanId(null);

      assertEquals(someBeanId, beanId);

    } finally {
      // ---------------
      // restore the original defaultServer instance
      // ---------------
      mockiEbean.restoreOriginal();
    }

    EbeanServer restoredServer = Ebean.getServer(null);
    assertTrue("is a real EbeanServer", restoredServer instanceof DefaultServer);
  }

```
<h4>MoickiEbean Maven dependency</h4>
```xml
<dependency>
  <groupId>org.avaje.ebeanorm</groupId>
  <artifactId>avaje-ebeanorm-mocker</artifactId>
  <version>1.0.1</version>
  <scope>test</scope>
</dependency>
```
</div>
