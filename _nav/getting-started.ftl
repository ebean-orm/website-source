<@nav0 activeCheck="${n0_start!''}" url="/docs/getting-started" title="Getting started">
  <ul>
    <@nav1 activeCheck="${n1_idea!''}" url="/docs/getting-started/intellij-idea" title="IntelliJ"/>
    <@nav1 activeCheck="${n1_eclipse!''}" url="/docs/getting-started/eclipse-ide" title="Eclipse"/>
    <@nav1 activeCheck="${n1_cli!''}" url="/docs/getting-started/cli-tool" title="CLI Tool"/>
    <@nav1 activeCheck="${n1_maven!''}" url="/docs/getting-started/maven" title="Maven">
      <ul class="nav nav-scroll">
        <@smallnav activeCheck="" url="#dependencies" title="Dependencies"/>
        <@smallnav activeCheck="" url="#tile" title="Tile"/>
      </ul>
    </@nav1>
    <@nav1 activeCheck="${n1_gradle!''}" url="/docs/getting-started/gradle" title="Gradle"/>
    <@nav1 activeCheck="${n1_test!''}" url="/docs/getting-started/ebean-test" title="Test setup"/>
  </ul>
</@nav0>
