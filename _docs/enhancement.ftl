<div class="bs-docs-section">
<h1 id="enhancement" class="page-header">Enhancement</h1>

<p>The term "Enhancement" covesr all the ways (javaagent, ant, maven,IDE plugin, etc)
that are used to modify the entity beans.<p>

<p>Other similar terms to Enhancement that are used  include Weaving,
Transformation and byte code manipulation.</p>

<p>LTW – Load time weaving is used to refer to when the class manipulation occurs at "load
time" typically via javaagent compared with class manipulation occuring at "build time"
typically via Maven, Ant or IDE plugin.</p>

<p>In raw terms a class is just a byte[] and Ebean is simply manipulating those bytes prior to
the class being defined by its ClassLoader.</p>


<div class="row icon-info">
<div class="col-md-3">
  <div class="well">
  <h4><span class="glyphicon glyphicon-chevron-right"></span> Maven, Ant</h4>
  <p>
Use Maven or Ant to enhance your beans at build compile time.
  </p>
  </div>
</div>

<div class="col-md-3">
  <div class="well">
  <h4><span class="glyphicon glyphicon-chevron-right"></span> Agent, AgentLoader</h4>
  <p>
Specify the agent on the command line or use AgentLoader to load the agent via code
onto a running JVM.
  </p>
  </div>
</div>

<div class="col-md-3">
  <div class="well">
  <h4><span class="glyphicon glyphicon-chevron-right"></span> Idea, Eclipse IDE</h4>
  <p>
Use IDE plugin to run the enhancement as part of the IDE compile/save.
  </p>
  </div>
</div>
</div> <!-- ./row -->

<div class="row">
<div class="col-md-12">

<#-------------------------------------------------------------------------------------------------->
<h2 id="enhance_maven">Maven enhancement</h2>
<p>A Maven plugin for build time enhancement</p>

<@maven_replace_version "::version::" "avaje-ebeanorm-mavenenhancer">
```xml
<plugin>
  <groupId>org.avaje.ebeanorm</groupId>
  <artifactId>avaje-ebeanorm-mavenenhancer</artifactId>
  <version>::version::</version>
  <executions>
     <execution>
      <id>main</id>
      <phase>process-classes</phase>
      <configuration>
        <classSource>target/classes</classSource>
        <classDestination>target/classes</classDestination>
        <packages>org.example.domain.**,org.example.anotherdomain.**</packages>
        <transformArgs>debug=1</transformArgs>
      </configuration>
      <goals>
        <goal>enhance</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```
</@maven_replace_version>


<#-------------------------------------------------------------------------------------------------->
<h2 id="enhance_maven_eclipse">Eclipse + Maven enhancement</h2>
<p>Eclipse can be configured to enhance the classes during build using maven configuration</p>

<@maven_replace_version "::version::" "avaje-ebeanorm-mavenenhancer">
```xml
<build>
    <plugins>
        <!-- plugins here -->
    </plugins>
    <pluginManagement>
        <plugins>
            <!--This plugin's configuration is used to store Eclipse m2e settings only. It has no influence on the Maven build itself. -->
            <plugin>
                <groupId>org.eclipse.m2e</groupId>
                <artifactId>lifecycle-mapping</artifactId>
                <version>1.0.0</version>
                <configuration>
                    <lifecycleMappingMetadata>
                        <pluginExecutions>
                            <pluginExecution>
                                <pluginExecutionFilter>
                                    <groupId>org.avaje.ebeanorm</groupId>
                                    <artifactId>avaje-ebeanorm-mavenenhancer</artifactId>
                                    <versionRange>[::version::,)</versionRange>
                                    <goals>
                                        <goal>enhance</goal>
                                    </goals>
                                </pluginExecutionFilter>
                                <action>
                                    <execute>
                                        <runOnConfiguration>true</runOnConfiguration>
                                        <runOnIncremental>true</runOnIncremental>
                                    </execute>
                                </action>
                            </pluginExecution>
                        </pluginExecutions>
                    </lifecycleMappingMetadata>
                </configuration>
            </plugin>
        </plugins>
    </pluginManagement>
</build>
```
</@maven_replace_version>


<#-------------------------------------------------------------------------------------------------->
<h2 id="enhance_ant">Ant enhancement</h2>
<p>Modify your ant build.xml file to:
  <ol>
    <li>Define the AntEnhanceTask.</li>
    <li>Create a target that uses the AntEnhanceTask to enhance the entity classes.</li>
  </ol>
</p>

```xml
<taskdef
    name="ebeanEnhance"
    classname="com.avaje.ebean.enhance.ant.AntEnhanceTask"
    classpath="your_path_to/ebean-x.x.x.jar" />

<target name="ormEnhance" depends="clean,compile">
 <!--
 classSource: This is the directory that contains your class files. That is, the directory where your IDE will compile your java class files to, or the directory where a previous ant task will compile your java class files to.

 classDest: The directory where the enhanced classes are written to. If not specified this defaults to the classSource effectively replacing the original class file with the enhanced class file.

 packages: a comma delimited list of packages that contain entity classes. All the classes in these packages are searched for entity classes to be enhanced. transformArgs: This contains a debug level (0 - 10) .
 -->
 <ebeanEnhance
    classSource="your_classes_directory"
    packages="app.entity*"
    transformArgs="debug=5" />
</target>
```
</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="enhance_agent">Agent enhancement</h2>
<p>JVM javaagent for runtime enhancement - you will usually start the JVM with an -javaagent:lib/avaje-ebeanorm-agent.jar command line option.  Ebean will automatically enhance the beans and use the resulting subclasses instead</p>
<@maven "org.avaje" "avaje-agentloader" "auto" "3" />

<p>Enables programmatic loading of the java agent instead of starting the jvm with the -javaagent command line option</p>
<@maven "org.avaje.ebeanorm" "avaje-ebeanorm-agent" "auto" "4" />

Next, you need to start the enhancer agent.  You can start the enhancer agent programmatically:
```java
import org.avaje.agentloader;
...
public void someApplicationBootupMethod() {
  // Load the agent into the running JVM process
  if (!AgentLoader.loadAgentFromClasspath("avaje-ebeanorm-agent","debug=1;packages=org.example.model.**")) {
    logger.info("avaje-ebeanorm-agent not found in classpath - not dynamically loaded");
  }
}
```

Alternatively, you can start the enhancer agent from the command line, examples:
<@maven_replace_version "::version::" "avaje-ebeanorm-mavenenhancer">
```xml
java -javaagent:avaje-ebeanorm-agent-::version::.jar MyApplication
java -javaagent:avaje-ebeanorm-agent-::version::.jar=debug=3 MyApplication
java -javaagent:avaje-ebeanorm-agent-::version::.jar=packages=org.example.model.** MyApplication
java -javaagent:avaje-ebeanorm-agent-::version::.jar=debug=3;packages=org.example.model.**,org.example.model2.** MyApplication
```
</@maven_replace_version>


And as a final alternative, you can enhance your entities yourself programmatically with the agent:

```java
Transformer transformer = new Transformer("", "debug=" + EBEAN_TRANSFORM_LOG_LEVEL);//0-9 -> none - all
InputStreamTransform streamTransform = new InputStreamTransform(transformer, Ebean.class.getClassLoader());
InputStream in = new URL("your.class.file.class").openStream();//Or use ASM or Javassist get bytecode and new InputSream eg. in = new ByteArrayInputStream(ctClass.toBytecode());
byte[] result = null;
try {
    result = streamTransform.transform("your.class.name", in);//class must be not loaded by classLoader
} finally {
    in.close();
}
if (result == null) {
    throw new CannotCompileException("ebean enhance model fail!");
}
defineClass("your.class.name", result, 0, result.length);
```


</p>

<#-------------------------------------------------------------------------------------------------->
<h2 id="enhance_ide">IDE enhancement</h2>
<p>Under Construction</p>
</div>
</div> <!-- ./row -->

</div>
