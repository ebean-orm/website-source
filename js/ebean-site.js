
$(function() {

  // setup page scrolling feature - uses jquery.easing
  $('a.page-scroll').bind('click', function(event) {
    var $anchor = $(this);
    $('html, body').stop().animate({
        scrollTop: $($anchor.attr('href')).offset().top - $(".navbar").height()
    }, 1500, 'easeInOutExpo');
    event.preventDefault();
  });

  // update pages with artifact versions from ajax call to search.maven.org
  retrieveAndReplaceVersionsInPage();


    // Scrollspy
    var $window = $(window)
    var $body   = $(document.body)

    $body.scrollspy({
      target: '.bs-docs-sidebar'
    })
    $window.on('load', function () {
      $body.scrollspy('refresh')
    })

    // Kill links
    $('.bs-docs-container [href=#]').click(function (e) {
      e.preventDefault()
    })

    // Sidenav affixing
    setTimeout(function () {
      var $sideBar = $('.bs-docs-sidebar')

      $sideBar.affix({
        offset: {
          top: function () {
            var offsetTop      = $sideBar.offset().top
            var sideBarMargin  = parseInt($sideBar.children(0).css('margin-top'), 10)
            var navOuterHeight = $('.bs-docs-nav').height()

            return (this.top = offsetTop - navOuterHeight - sideBarMargin)
          },
          bottom: function () {
            return (this.bottom = $('.bs-docs-footer').outerHeight(true))
          }
        }
      })
    }, 100)

});

function retrieveAndReplaceVersionsInPage() {
  if ($.sessionStorage.isSet('versions')) {
    console.log("retrieving from storage");
    replaceVersionsInPage();
  } else {
    console.log("retrieving from url");
    getVersionsFromUrl('http://jsonp.afeld.me/?url=http://search.maven.org/solrsearch/select?q=g:%22org.avaje.ebeanorm%22%20OR%20(g:%22org.avaje%22%20AND%20a:%22avaje-agentloader%22)&wt=json');
  }
}

function getVersionsFromUrl(url) {
  $.ajax({
    type: 'GET',
    url: url,
    async: true,
    contentType: "application/json",
    dataType: 'jsonp'
  }).then(function(data){
    var projs = data.response.docs;
    var versions = {};

    for(var i = 0; i < projs.length; i++) {
      var p = projs[i];
      var artifactid = p.a;
      versions[artifactid]=p.latestVersion;
    }

    $.sessionStorage.set('versions', versions);
    replaceVersionsInPage();
  });
}

// Find <span class="${artifactid}-version"></span> tags and fill with the artifacts version
function replaceVersionsInPage() {
  var versions = $.sessionStorage.get('versions');

  $.each(versions, function(artifactid, version) {
    $("span."+artifactid+"-version").text(version);
  });
}
