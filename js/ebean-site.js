
$(function() {

  // update pages with artifact versions from ajax call to search.maven.org
  retrieveAndReplaceVersionsInPage();


  // Adjust scrolling in pages for fixed header
  var offset = 50;


  // handle clicks on website, if link starts with #, handle here
  $('a').bind ('click', function(event) {
      var $anchor = $(this);

      var href = $anchor.attr("href");

      if (href.slice(0, 1) === "#") {
        event.preventDefault();

        if ($anchor.hasClass("page-scroll")) {
          //  uses jquery.easing to animate scrolling
          $('html, body').stop().animate({
              scrollTop: $(href).offset().top - offset
          }, 1500, 'easeInOutExpo');
        } else {
          // go to location quickly
          $(href)[0].scrollIntoView();
          scrollBy(0, -offset);
        }
      }
  });


  // Scrollspy
  var $window = $(window)
  var $body   = $(document.body)

  $body.scrollspy({
    offset: 60,
    target: '.bs-docs-sidebar'
  })
  $window.on('load', function () {
    $body.scrollspy('refresh')
  })

  // Sidenav affixing
  setTimeout(function () {
    var $sideBar = $('.bs-docs-sidebar')

    $sideBar.affix({
      offset: {
        top: function () {
          var offsetTop      = $sideBar.offset().top
          var sideBarMargin  = parseInt($sideBar.children(0).css('margin-top'), 10)
          var navOuterHeight = $('.navbar-fixed-top').height()

          return (this.top = offsetTop - navOuterHeight - sideBarMargin)
        },
        bottom: function () {
          return (this.bottom = $('#footer').outerHeight(true))
        }
      }
    })
  }, 100)

});

function retrieveAndReplaceVersionsInPage() {
  if ($.sessionStorage.isSet('ebean-versions')) {
    console.log("retrieving from storage");
    replaceVersionsInPage();
  } else {
    console.log("retrieving from url");
    getVersionsFromUrl('http://jsonp.afeld.me/?url=http://search.maven.org/solrsearch/select?q=g:%22io.ebean%22%20OR%20(g:%22io.ebean%22%20AND%20a:%22ebean%22)&wt=json');
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

    $.sessionStorage.set('ebean-versions', versions);
    replaceVersionsInPage();
  });
}

// Find <span class="${artifactid}-version"></span> tags and fill with the artifacts version
function replaceVersionsInPage() {
  var versions = $.sessionStorage.get('ebean-versions');

  $.each(versions, function(artifactid, version) {
    $("span."+artifactid+"-version").text(version);
  });
}
