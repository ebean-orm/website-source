

<#macro maven groupid artifactid version uq >

<#if version == "auto">
  <#assign version_auto = true />
  <#assign version_str = "/ver:${artifactid}:ver/" />
<#else>
  <#assign version_auto = false />
  <#assign version_str = version />
</#if>

  <#--  uq= uq value to be added to html ids for each macro instance -->

  <div role="tabpanel">

    <ul class="nav nav-tabs" role="tablist">
      <li role="presentation" class="active"><a href="#Maven${uq}" aria-controls="Maven${uq}" role="tab" data-toggle="tab">Maven</a></li>
      <li role="presentation"><a href="#Ivy${uq}" aria-controls="Ivy${uq}" role="tab" data-toggle="tab">Ivy</a></li>
      <li role="presentation"><a href="#Grape${uq}" aria-controls="Grape${uq}" role="tab" data-toggle="tab">Grape</a></li>
      <li role="presentation"><a href="#Gradle${uq}" aria-controls="Gradle${uq}" role="tab" data-toggle="tab">Gradle</a></li>
      <li role="presentation"><a href="#Buildr${uq}" aria-controls="Buildr${uq}" role="tab" data-toggle="tab">Buildr</a></li>
      <li role="presentation"><a href="#SBT${uq}" aria-controls="SBT${uq}" role="tab" data-toggle="tab">SBT</a></li>
      <li role="presentation"><a href="#Leiningen${uq}" aria-controls="Leiningen${uq}" role="tab" data-toggle="tab">Leiningen</a></li>
    </ul>

<#local dep_block>
    <div class="tab-content">
      <div role="tabpanel" class="tab-pane active" id="Maven${uq}">
```xml
<dependency>
  <groupId>${groupid}</groupId>
  <artifactId>${artifactid}</artifactId>
  <version>${version_str}</version>
</dependency>
```
      </div>
      <div role="tabpanel" class="tab-pane" id="Ivy${uq}">
```xml
<dependency org="${groupid}" name="${artifactid}" rev="${version_str}"/>
```
      </div>
      <div role="tabpanel" class="tab-pane" id="Grape${uq}">
```groovy
@Grapes(
  @Grab(group='${groupid}', module='${artifactid}', version='${version_str}')
)
```
      </div>
      <div role="tabpanel" class="tab-pane" id="Gradle${uq}">
```groovy
'${groupid}:${artifactid}:${version_str}'
```
      </div>
      <div role="tabpanel" class="tab-pane" id="Buildr${uq}">
```groovy
'${groupid}:${artifactid}:${version_str}'
```    </div>
      <div role="tabpanel" class="tab-pane" id="SBT${uq}">
```scala
libraryDependencies += "${groupid}" % "${artifactid}" % "${version_str}"
```
      </div>
      <div role="tabpanel" class="tab-pane" id="Leiningen${uq}">
```xml
[${groupid}/${artifactid} "${version_str}"]
```
      </div>
    </div>
</#local>
<#if version_auto == true>
${dep_block?replace("/ver:"+artifactid+":ver/", "<span class='"+artifactid+"-version'>$"+"{version}</span>" )}
<#else>
${dep_block}
</#if>

  </div>
</#macro>

<#macro maven_replace_version placeholder artifactid>
<#local dep_block><#nested></#local>
${dep_block?replace(placeholder, "<span class='"+artifactid+"-version'>$"+"{version}</span>" )}
</#macro>


<#macro video_item id title body cls="">
<div class="media ${cls}">
  <div class="media-left">
    <div class="media-left">
  <#if id == "">
    <img src="/images/movies-64-grey.png" width="64" height="64" >
  <#else>
    <a href="https://youtu.be/${id}">
      <img src="/images/movies-64.png" width="64" height="64" >
    </a>
  </#if>
    </div>
  </div>
  <div class="media-body">
    <h4 class="media-heading">${title}</h4>
  ${body}
  </div>
</div>
</#macro>
