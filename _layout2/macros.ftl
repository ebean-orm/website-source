<#macro nav0 activeCheck url title>
  <li class="nav0 <#if activeCheck?has_content>active</#if>">
    <a <#if activeCheck?has_content>class="active"</#if> href="${url}">${title}</a>
    <#if activeCheck?has_content>
      <#nested >
    </#if>
  </li>
</#macro>
<#macro nav1 activeCheck url title>
  <li class="nav1 <#if activeCheck?has_content>active</#if>">
    <a <#if activeCheck?has_content>class="active"</#if> href="${url}">${title}</a>
    <#if activeCheck?has_content>
      <#nested >
    </#if>
  </li>
</#macro>

<#macro smallnav activeCheck url title>
  <li <#if activeCheck?has_content>class="active"</#if>>
    <a <#if activeCheck?has_content>class="active"</#if> href="${url}">${title}</a>
    <#if activeCheck?has_content>
      <#nested >
    </#if>
  </li>
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
  <nav class="next">
    <p class="edit-page">
      <a href="https://github.com/ebean-orm/website-source/blob/master${href}"><i class="fab fa-github"></i> Edit Page</a>
    </p>
  </nav>
</#macro>

<#macro next title href>
  <nav class="next">
    <p class="next">
      <a href="${href}" class="btn btn-info">Next: ${title}</a>
    </p>
  </nav>
</#macro>

<#macro next_edit title href editHref>
  <nav class="next">
    <p class="edit-page">
      <a href="https://github.com/ebean-orm/website-source/blob/master${editHref}"><i class="fab fa-github"></i> Edit Page</a>
    </p>
    <p class="next">
      <a href="${href}" class="btn btn-info">Next: ${title}</a>
    </p>
  </nav>
</#macro>

<#macro pgedit editHref>
  <#if editHref?has_content><a href="https://github.com/ebean-orm/website-source/blob/master${editHref}"><i class="fab fa-github"></i> edit page</a></#if>
</#macro>

<#macro edit editHref>
  <nav class="next">
    <p class="edit-page">
      <a href="https://github.com/ebean-orm/website-source/blob/master${editHref}"><i class="fab fa-github"></i> Edit Page</a>
    </p>
  </nav>
</#macro>

<#macro edit_rhs editHref>
  <nav class="next">
    <p class="edit-page next">
      <a href="https://github.com/ebean-orm/website-source/blob/master${editHref}"><i class="fab fa-github"></i> Edit Page</a>
    </p>
  </nav>
</#macro>

