<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta id="layout-head" />
  <title>Ebean ORM - Java/Kotlin/JVM</title>
  <link rel="shortcut icon" href="/images/favicon.ico" >
  <!--<link href="/css/bootstrap.min.css" rel="stylesheet">-->
  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <link rel="stylesheet" href="/css/pygments.css" type="text/css" />
  <link rel="stylesheet" href="/css/site.css">
  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css">
<#macro navlink activeCheck url title>
  <li <#if activeCheck?has_content>class="active"</#if>>
    <i class="fa fa-chevron-right"></i> <a href="${url}">${title}</a>
  </li>
</#macro>
  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>