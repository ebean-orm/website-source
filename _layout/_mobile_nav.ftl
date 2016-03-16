<#if locationBar??>
  <div class="locationBar">${locationBar}</div>
  <div class="sideNav"><ul class="nav navbar-nav">${sideNav}</ul></div>
<#else>
  <#include "/_layout/_desktop_nav.ftl">
</#if>
