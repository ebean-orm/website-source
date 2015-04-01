<div class="bs-docs-section">
<h1 id="json">JSON</h1>
...(under construction)...

<p>

Ebean can hydrate a bean from json.  It will ignore the json properties that do not match up to properties on the bean.

```java
String jsonWithUnknown = "{\"id\":42, \"unknownProp\":\"foo\", \"name\":\"rob\", \"version\":1}";

Customer customer = Ebean.json().toBean(Customer.class, jsonWithUnknown);
assertEquals(Integer.valueOf(42), customer.getId());
assertEquals("rob", customer.getName());
```

</p>
</div>
