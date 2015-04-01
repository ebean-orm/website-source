<h2 id='jaxrs_integration'>JAX-RS integration</h2>

<p>
Provides integration with using Ebean with JAX-RS.
</p>
<p>
Specifically it integrates Ebean's JSON (not XML yet) marshalling and unmarshalling support and provides some integration to make it easier to use Entity Beans with JAX-RS.
</p>
<p>
The com.avaje.ebean.jaxrs package needs to be registered with JAX-RS so that it finds Ebean's JaxrsJsonProvider. This provides the JSON Marshalling and Unmarshalling of entity beans.
</p>
<p>
If you use custom Media types then you might need to subclass the JaxrsJsonProvider and register it with those media types.
</p>
<p>
Typically developers will extend the AbstractEntityResource object which has built in support for many typical functions such as find by id, find all, insert, update, delete and delete many by ids.
</p>

<p>
Example:
```java
...
// Extend AbstractEntityResource to get:
//   Insert, Update, Delete, Delete Many, Find by Id and Find all
//
// Use uriOptions to allow client to customise exactly
// the properties to fetch and render (rather than get
// the server to provide more API).
//
@Path("/customer{uriOptions:(:[^/]+?)?}/")
@Produces({MediaType.APPLICATION_JSON, "text/json"})
public class CustomerJsonResource extends AbstractEntityResource {

    public CustomerJsonResource() {
        super(Customer.class);
    }
}
```
</p>

<h4>AbstractEntityResource provides:</h4>
<p>
AbstractEntityResource provides an implementation for
 Insert, Update, Delete, Delete Many, Find by Id and Find all.
It makes use of UriOptions if defined.
</p>

```java
    /**
     * Insert a bean.
     *
     * @param bean
     *            the bean to insert
     */
    @POST
    public Response insert(@Context UriInfo uriInfo, T bean) {

    /**
     * Update a bean.
     *
     * @param id
     *            the unique id of the bean
     * @param bean
     *            the bean to update
     */
    @PUT
    @Path("/{id}")
    public void update(@PathParam("id") String id, T bean) {



    /**
     * Delete multiple beans using Id's from the "UriOptions".
     *
     * @param options
     *            The UriOptions in the form "::(id1,id2,...)"
     */
    @DELETE
    public void deleteMultiple(@PathParam("uriOptions") String options) {

    /**
     * Delete a bean using its id.
     *
     * @param id
     *            the unique id of the bean.
     */
    @DELETE
    @Path("/{id}")
    public void delete(@PathParam("id") String id) {

    /**
     * Find a bean given its Id.
     *
     * @param id
     *            the id of the bean.
     */
    @GET
    @Path("/{id}")
    public T find(@PathParam("id") String id, @PathParam("uriOptions") String uriOptions) {



    /**
     * Find all the beans for this beanType.
     * &lt;p&gt;
     * This can use URL query parameters such as order and maxrows to configure
     * the query.
     * &lt;p&gt;
     */
    @GET
    public List&lt;T&gt; findAll(@Context UriInfo ui, @PathParam("uriOptions") String uriOptions) {
```

<h4>UriOptions</h4>
<p>
Used to parse a String (typically from part of a URL) into PathProperties, List of Id's and sort clause which can then be applied to the JSON/XML marshaling and ORM query to optimise the building and rendering of part of an object graph.
</p>
<p>
UriOptions was inspired by the JavaOne presentation from LinkedIn on
building High performance restful APIS's. That presentation is available
<a href="http://www.slideshare.net/linkedin/building-consistent-restful-apis-in-a-highperformance-environment">on slideshare.net</a>.
</p>
<p>
Essentially UriOptions gives the caller the ability to specify only
the properties they need. This gives the server implementation the
ability to optimise the marshalling and ORM query without extra
server API's (which would otherwise need to be built and documented).
</p>
<p>
The UriOptions can contain 3 segments to specify:<br/>
- A list of Id's to fetch or delete<br/>
- The properties to fetch (can be nested) <br/>
- A sort clause <br/>
</p>

```java
 Example URL:
 .../v1/customer::(34,35):(name,id,contacts(firstName,lastName)):sort(id desc)

 The 3 segments above is broken into:


 ::(34,35)
 // fetch customer 34 and 35

 :(name,id,contacts(firstName,lastName))
 // fetch customer name, id the customer contacts firstName and lastName

 :sort(id desc)
 // sort the customers by descending order of their Id values
```
