<h1>Where does Ebean come from?</h1>

<p>
    Hi, I'm Robin Bygrave and I am the main contributor to Ebean ORM. This is the background story of how
    Ebean ORM has come to be.
</p>


<h2>DB Design</h2>
<p>
  The Courses at the University of Auckland cover SQL, DB Design, Normalisation, Structured Analysis and Design.
</p>
<p>
  Some 20 years later and much of this
</p>
<p class="bs-callout bs-callout-info">
  Ultimately DB Design is a natural .
</p>

<h2>Oracle RDBMS, Client/Server</h2>
<p class="bs-callout bs-callout-info">
   Oracle RDBMS Internals, Client/Server
</p>
<p>
  I was lucky enough to work for Oracle in the early part of my career.  This certainly provides a lot of
    bias as to how I see ORM. To put a caveat on this my knowledge of Oracle internals dates back to
    Oracle 8 and when I look at Oracle Exadata its obvious that all assumptions need to be questioned.
</p>
<ul>
    <li>MVCC - Readers don't block writers</li>
    <li>Select only what you need - can skip reading data blocks etc</li>
    <li>Cost based optimiser - kind a Sucks when you don't have one</li>
    <li>Spread IO</li>
</ul>
<p class="bs-callout bs-callout-info">
    Oracle ERP - Large modular Client/Server working well
</p>
<p>
  Oracle RDBMS than Oracle Forms (Array fetch, fetch ahead buffer etc).
  Oracle ERP is a massive client server application built using Oracle Forms - it is well designed and modular.
    It has stored procedure API's and 'interface tables' for third parties and customers to integrate with.
    Client/Server is working well.
</p>
<p class="bs-callout bs-callout-info">
    2 Tier Client/Server hitting a limit
</p>
<p>
  There are big client server deployments but we are starting to hit a fundamental architectural issue with 2 tier
    Client/Server where every client has a persistent connection to the database.
</p>
<p class="bs-callout bs-callout-info">
    Sedona - DCOM version of Corba/EJB - The rumblings of Distributed Objects
</p>
<p>
  In a big internal meeting of the Oracle Tools team we get a demo of Project Sedona. This is a DCOM Windows only
    distributed objects solution. Project Sedona doesn't get out the door as Java comes out. Sedona was in many ways
    a DCOM version of Corba and later EJB.
</p>
<h2>SilverStream 3 Tier Client/Server - Java Developer</h2>
<p class="bs-callout bs-callout-info">
    3 Tier client server happy place
</p>
<p>
  I land a job with SilverStream which is a Java Application Server vendor. It has a 3 tier
    client server architecture with Co-Founder and many developers from PowerBuilder. We are very successful building
    3 tier client/server intranet applications with a Java front end or a HTML front end.
</p>
<p class="bs-callout bs-callout-info">
  Public internet and high loads
</p>
<p>
  I lead a small development team building SilverStreams first public internet website. We decide to use a cache
    (I write a concurrent HashTable, ConcurrentHashMap doesn't exist), we write a simple templating mechanism to get
    the content into the cache, we use a light persistence layer above JDBC. It all works, however a sister project
    being built at the same time using a more tradtional SilverStream approach dies under load - we manically re-architect.
</p>
<p>
  Client server works well for the intranet but on for public sites caching is key. We also need templating
    library that we can use to generate content offline and populate the cache and a performant persistence layer.
</p>
<h2>EJB 1.0</h2>
<p class="bs-callout bs-callout-info">
   Distributed Objects ... well, this is not going to help
</p>
<p>
  The EJB Spec to me read like a nightmare - All the EJB's talk to each other via RMI and with that an external
    transaction manager. That isn't solving my problems but just adding new ones.
    On top of the extra network hops in all my years at Oracle I had seen very few people using an external tranaction
    manager due to the extra cost of XA. The Entity Beans to me look especially stupid.
    SilverStream adopts the EJB spec and it seems to me that the EJB Spec came out with some magic pickie dust because
    no one I talk to is concerned. I get to avoid EJB and do CMS work for public sites.
</p>

<h3>NZ - Avoiding EJB / Hello Hibernate</h3>
<p>
  The magic pixie dust seemed to lose half it's power on its trip down under and I successfully avoid EJB/J2EE/JEE
    for the rest of my career (to date). Velocity and Freemaker suit my templating needs. Caching is now well covered
    and of course I have a persistence layer which is working well and it has some nice Lucene integration.
</p>
<p class="bs-callout bs-callout-info">
  Hello Hibernate ... what the heck is that Session thing?
</p>
<p>
  I knew a fair bit about databases, I knew the JDBC API really well, I had a pretty mature persistence layer that
    worked much like how Oracle Forms had worked with dirty checking and optimistic concurrency control etc.
    The Hibernate Session object was a foreign crazy concept that to me clearly put the dirty state in the wrong place
    and it all went bad from there. Why would anyone like that?
</p>
<p class="bs-callout bs-callout-info">
  Hibernate - you're dirty state is in the wrong place
</p>
<p>
  If I added the ORM features to my existing persistence layer that would be much easier to use compared to Hibernate.
    You avoid any pain passing around the Session object, make the persisting all nice and explicit and avoid dealing
    with the failure cases where a Session object has some good and some bad beans.
    I really enjoy working in the JavaSE environment and was pretty sure I didn't want to deal with this crazy Session
    object for the rest of my development career.
</p>
<p class="bs-callout bs-callout-info">
  JPA 1.0 - All ORM's are session based?
</p>
<p>
  So Toplinks UnitOfWork maps to Hibernate's Session, the JDO vendors have a PersistenceManager and similar lifecycle.
    Are all ORM's session based?  Well no, because there is one in the .Net space and I'm going to build one in Java.
</p>
<p class="bs-callout bs-callout-info">
    JPQL - Partial Objects
</p>
<p>
  In building Ebean ORM against the JPA Spec and some things strike me as just completely crazy from a SQL performance perspective.
    The Eager/Lazy fetching is statically defined and JPQL does not support Partial Objects - how the heck are people
    going to support multiple use cases against the same objects when the query access is statically defined? The answer
    comes in JPA 2 with FetchGroups - hmmm, it should really have been part of the query language.
</p>
<h2>How to create an ORM</h2>
<p class="bs-callout bs-callout-info">
  I can build an ORM without the Session/UnitOfWork/EntityManger - and that makes it much easier to use.
    Time to roll up the sleeves.
</p>
<ol>
    <li>Take a Relational Persistence Layer (with the dirty state on the beans themselves of course)</li>
    <li>Add some enhancement goodness (Thanks ASM)</li>
    <li>Replace Foreign Keys with Associations</li>
    <li>Add a PersistenceContext (only used for consistent object graph construction)</li>
    <li>Define a Query Language with Partial Object support (because performant SQL is important)</li>
    <li>Support Query joins and batch lazy loading (because performance is important)</li>
</ol>
<p>
  Well, it sounds easy enough but obviously there has been a huge effort gone into Ebean over some years now.
    There has been a lot of effort into making it generate good performant SQL including
    defining a sensible query language, supporting Partial Objects, Query joins, Batch lazy loading
    and Autofetch query tuning. Additionally I didn't get some of the internals right and a few refactoring
    efforts have been needed.
</p>
<p>
  Ebean is not 'done' yet - slowly but surely we will get there.  For those people who want to use an ORM without the
    crazy Session/EntityManager/PersistenceManager - well, you can try it out.
</p>
