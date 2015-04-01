<div class="bs-docs-section">
<h1 id="clustering">Clustering</h1>

<p>...(under construction)... needs reviewed</p>

<p>
Use ContainerConfig Configuration for the container that holds the EbeanServer instances.
</p><p>
Provides configuration for cluster communication (if clustering is used). The cluster communication is used to invalidate appropriate parts of the L2 cache across the cluster.
</p>

```java
private ContainerConfig createContainerConfig(String local, String threadPoolName) {
    ContainerConfig container = new ContainerConfig();
    container.setMode(ContainerConfig.ClusterMode.SOCKET);  // also CusterMode.MULTICAST

    ContainerConfig.SocketConfig socketConfig = new ContainerConfig.SocketConfig();
    socketConfig.setLocalHostPort(local);
    socketConfig.setThreadPoolName(threadPoolName);
    socketConfig.setMembers(Arrays.asList("127.0.0.1:9876", "127.0.0.1:9866"));

    container.setSocketConfig(socketConfig);
    return container;
  }
```

```java
// Startup server 1
ContainerConfig container = createContainerConfig("127.0.0.1:9876", "pool0");
ClusterManager mgr = new ClusterManager(container);

// Create your ebean server as you normally do
EbeanServer server = ...;

// Register the EbeanServer with the cluster manger
mgr.registerServer(server);

// Register the cluster manager with the cluster
mgr.startup();

// Deregister the cluster manager from the cluster
mgr.shutdown();
```

Same code different port:
```java
// Startup server 2
ContainerConfig container = createContainerConfig("127.0.0.1:9866", "pool1");

ClusterManager mgr = new ClusterManager(container);

ServerConfig serverConfig = ...;

EbeanServer server = EbeanServerFactory.create(config);
mgr.registerServer(server);

// Create your ebean server as you normally do
EbeanServer server = ...;

// Register the EbeanServer with the cluster manger
mgr.registerServer(server);

// Register the cluster manager with the cluster
mgr.startup();

// Deregister the cluster manager from the cluster
mgr.shutdown();
```
</p>


<h4>Other notes</h4>
<p>The <a href="/apidocs/com/avaje/ebean/event/AbstractBeanPersistListener.html">BeanPersistListener</a> listens for committed bean events.</p>

<p>These listen events occur after a successful commit. They also occur in a background thread rather than the thread used to perform the actual insert update or delete. In this way there is a delay between the commit and when the listener is notified of the event.</p>

<p>For a cluster these events may need to be broadcast. Each of the inserted(), updated() and deleted() methods return true if you want those events to be broadcast to the other members of a cluster (the id values are broadcast). If these methods return false then the events are not broadcast.</p>

<p>
  Ebean.externalModification(String tableName, boolean inserted, boolean updated, boolean deleted) processes committed changes from another framework or clustered server
</p>

<p>
Calling Ebean.externalModification notifies Ebean that beans have been committed externally, either by another framework or clustered server. Ebean uses this information to maintain its cache and lucene indexes appropriately.
</p>


</div>
