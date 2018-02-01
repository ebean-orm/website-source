<#macro smallnav activeCheck url title>
<li <#if activeCheck?has_content>class="active"</#if>>
  <a href="${url}">${title}</a>
  <#if activeCheck?has_content>
    <#nested >
  </#if>
</li>
</#macro>
<#macro homePlace>
  {asd}
</#macro>
<#--<li>-->
  <#--<a href="#introduction">Introduction</a>-->
  <#--<ul class="nav">-->
    <#--<li><a href="#use_jpa_mapping">Use JPA mappings</a></li>-->
    <#--<li><a href="#simple_query_language">Simple query language</a></li>-->
    <#--<li><a href="#intro_save_and_delete">Save and delete</a></li>-->
    <#--<li><a href="#jpa_comparison">Comparison to JPA</a></li>-->
    <#--<li><a href="#ebean_does_not">Ebean does not...</a></li>-->
  <#--</ul>-->
<#--</li>-->

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

<#macro menu_docs >
<div class="jumbotron mini">
    <div class="container">
        <form class="pull-right">
            <input class="form-control ds-input" id="search-input" placeholder="Search..." autocomplete="off" spellcheck="false" role="combobox" aria-autocomplete="list" aria-expanded="false" aria-owns="algolia-autocomplete-listbox-0" style="position: relative; vertical-align: top;" dir="auto" type="search">
        </form>
        <h1><a href="/docs">Documentation</a> <#nested>
    </div>
</div>
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

<#macro edit_page href>
<p class="edit-page">
  <a href="https://github.com/ebean-orm/website-source/blob/master${href}"><i class="fa fa-github"></i> Edit Page</a>
</p>
</#macro>
