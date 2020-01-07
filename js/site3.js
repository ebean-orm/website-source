$(function () {
  init();
});
function init() {
  setTheme(localStorage.getItem('theme'));
  showCodeLang(localStorage.getItem('lang'));
  showBuildTool(localStorage.getItem('buildTool'));
  scroll.init();
}
function toggleTheme() {
  const theme = localStorage.getItem('theme') === 'dark' ? 'light' : 'dark';
  localStorage.setItem('theme', theme);
  setTheme(theme);
}
function setTheme(theme) {
  if (theme === 'dark') {
    document.body.setAttribute("data-theme", "dark");
  } else {
    document.body.setAttribute("data-theme", "light")
  }
}
function setBuildTool(tool) {
  localStorage.setItem('buildTool', tool);
  showBuildTool(tool);
}
function setLang(lang) {
  localStorage.setItem('lang', lang);
  showCodeLang(lang);
}
function showBuildTool(tool) {
  if (tool === 'gradle') {
    $('.build-maven').hide();
    $('.build-gradle').show();
    $('.gradleActive').addClass('active');
    $('.mavenActive').removeClass('active');
  } else {
    $('.build-gradle').hide();
    $('.build-maven').show();
    $('.gradleActive').removeClass('active');
    $('.mavenActive').addClass('active');
  }
}
function showCodeLang(lang) {
  if (lang === 'kt') {
    $('.code-java').hide();
    $('.code-kt').show();
    $('.kotlinActive').addClass('active');
    $('.javaActive').removeClass('active');
  } else {
    $('.code-kt').hide();
    $('.code-java').show();
    $('.kotlinActive').removeClass('active');
    $('.javaActive').addClass('active');
  }
}

var scroll = {
  nav: false,
  current: null,
  list: [],
  init: function () {
    //$("nav.scroll ul li a")
    $("ul.nav-scroll li a").each(function () {
      var navItem = $(this);
      navItem.click(function() {
        scroll.navigate(navItem.parent());
      });
      scroll.list.push({'navItem': navItem.parent(), 'anchor': $(navItem.attr("href"))})
    });
    $(window).scroll(function () {
      scroll.update();
    });
  },
  navigate: function(item) {
    this.nav = true;
    this.activate(item);
  },
  activate: function(item) {
    if (item !== this.current) {
      if (this.current) {
        this.current.removeClass('active');
      }
      item.addClass('active');
      this.current = item;
    }
  },
  update: function () {
    if (this.nav) {
      this.nav = false;
    } else {
      const _top = $(window).scrollTop();
      let last = null;
      this.list.forEach(function (el) {
        if (_top > el.anchor.offset().top) {
          last = el;
        }
      });
      if (last) {
        this.activate(last.navItem);
      }
    }
  }
};
