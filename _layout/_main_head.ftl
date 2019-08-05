<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta id="layout-head" />
  <title>Ebean ORM - Java/Kotlin/JVM</title>
  <link rel="shortcut icon" href="/images/favicon.ico" >
  <script async defer src="https://buttons.github.io/buttons.js"></script>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.1.0/css/all.css" integrity="sha384-lKuwvrZot6UHsBSfcMvOkWwlCMgc0TaWr+30HWe3a4ltaBwTZhyTEggF5tJv8tbt" crossorigin="anonymous">
  <link rel="stylesheet" href="/css/pygments.css" type="text/css" />
  <link rel="stylesheet" href="/css/site.css">
<#macro navlink activeCheck url title>
  <li <#if activeCheck?has_content>class="active"</#if>>
    <i class="fa fa-chevron-right"></i> <a href="${url}">${title}</a>
  </li>
</#macro>
</head>
