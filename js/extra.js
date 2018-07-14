$(document).ready(function() {

  $('#searchinput').on('keydown', function(e) {
    const search_container = $('.search-results');
    let active = search_container.find('li.active');
    //console.log(active);
    //console.log('keydown', active);
    switch (e.keyCode) {
      case 13: // RETURN
        //console.log('RETURN');
        if (active.length === 0) {
          // Do nothing, do the normal behaviour.
        } else {
          e.preventDefault();
          document.location.href = active.find('a').attr('href');
          $('#searchinput').val('').blur();
          scrollBy(0, -100);
        }
        break;
      case 27: // ESC
        $('#searchinput').val('');
        e.preventDefault();
        $(this).blur();

        break;
      case 38: // UP
        e.preventDefault();
        //console.log('UP');

        for (let n = 0; n < 10; n++) { // Skip up to 10 links
          active.removeClass('active');
          if (active.length === 0 || active.prev().length === 0) {
            active = search_container.find('li').last().addClass('active');
          } else {
            active = active.prev().addClass('active');
          }
          if (active.find('a').length !== 0) break;
        }

        break;
      case 40: // DOWN
        e.preventDefault();
        for (let n = 0; n < 10; n++) { // Skip up to 10 links
          active.removeClass('active');
          if (active.length === 0 || active.next().length === 0) {
            active = search_container.find('li').first().addClass('active');
          } else {
            active = active.next().addClass('active');
          }
          // Found a link!
          if (active.find('a').length !== 0) break;
        }
        //console.log('DOWN');
        break;
    }
  });
  $(document).on('keypress', function(e) {
    // Capture events just in when come from the document.body
    //if (e.target === document.body) {
    if ($(e.target).attr('id') !== 'searchinput') {
      // 's' for search, and 't' as an alias compatible with github search in repo
      if (e.key === 's' || e.key === 't') {
        $('#searchinput').focus();
        e.preventDefault();
      }
      // '#' for hash and 'a' for anchor
      if (e.key === '#' || e.key === 'a') {
        $('#searchinput').focus();
        $('#searchinput').val('#');
        e.preventDefault();
      }
    }
  });
  var hideTimeout = 0;
  $('#searchinput').on('focus', function() {
    clearTimeout(hideTimeout);
    $('.search-results-inline-container').css('display', 'block');
    $(this).attr('placeholder', $(this).attr('data-placeholder-focus'));
    $(this).select();
  }).on('blur', function() {
    clearTimeout(hideTimeout);
    hideTimeout = setTimeout(function() {
      $('.search-results-inline-container').css('display', 'none');
    }, 250);
    $(this).attr('placeholder', $(this).attr('data-placeholder-blur'));
  });

  async function fetchSearch() {
    let res = await fetch("/search.json");
    let results = await res.json();
    for (const result of results) {
      result.category = String(result.category);
      result.title = String(result.title);
      result.caption = String(result.caption);
      result.categoryName = result.category || "";
      result.search = String('' + result.categoryName + ' ' + result.title + ' ' + result.caption + ' ' + result.keywords).normalizeForSearch();
    }
    return results;
  }

  let fetchSearchPromise = null;

  async function fetchSearchOnce() {
    fetchSearchPromise = fetchSearchPromise || fetchSearch();
    return await fetchSearchPromise;
  }

  // Prefetch
  fetchSearchOnce();

  function matchSearch(search, tokens) {
    let m = tokens.every(token => String(search).match(token));
    //if (!m) {
    //  console.log('no match ' + search)
    //}
    return m;
  }
  async function updateSearchResults() {
    //console.log("updateSearchResults ...");
    let query = $('#searchinput').val().trim();
    let containsHash = query.indexOf('#') >= 0;
    let querySearch = query.normalizeForSearch();
    //let querySearchForSection = querySearch.replace(/#/g, '');
    let searchResults = $('#search-results-container');
    let results = await fetchSearchOnce();

    let tokens = querySearch.split(' ');
    //console.log('tokens:  '+tokens);
    let filteredResultsAll = results
      .sorted(composeComparers(
        comparerBy((it) => it.priority || 0),
        comparerBy((it) => String(it.search))
      ))
      .filter(it => matchSearch(it.search, tokens));

    let filteredResults = filteredResultsAll.slice(0, 10);

    $(".doc-content").find("h3,h4,h5").filter("[id]").each(function () {
      const id = $(this).attr('id');
      const headerText = $(this).text();
      const searchTextLC = `${headerText} ${id}`.normalizeForSearch();
      if (searchTextLC.match(querySearch)) {
        lines.push(`<a href='#${id.escapeHTML()}'># ${headerText.escapeHTML()}</a>`);
      }
    });

    let lines = [];
    for (const result of filteredResults) {
      const capHtml = (result.caption && result.caption.escapeHTML()) ? `- ${result.caption.escapeHTML()}`: '';
      if (result.title === '') {
        //const catHtml = (result.category && result.category.escapeHTML()) ? `<span style="color:#777;">${result.category.escapeHTML()}</span> -`: '';
        lines.push(`<a href="${result.url.escapeHTML()}" title="${result.category.escapeHTML()}">${result.category.escapeHTML()} ${capHtml}</a>`);
      } else {
        const catHtml = (result.category && result.category.escapeHTML()) ? `<span style="color:#777;">${result.category.escapeHTML()}</span> -`: '';
        lines.push(`<a href="${result.url.escapeHTML()}" title="${result.title.escapeHTML()}">${catHtml} ${result.title.escapeHTML()} ${capHtml}</a>`);
      }
    }
    if (filteredResults.length < filteredResultsAll.length) {
      const invisibleLinks = filteredResultsAll.length - filteredResults.length;
      lines.push(`<small style="color:#999;">And ${invisibleLinks} more...</small>`);
    }
    if (query !== '' && !containsHash) {
      lines.push(`<a href="https://www.google.com/search?q=site:ebean-orm.github.io+${encodeURIComponent(query.trim())}">Search <code>${query.trim().escapeHTML()}</code> in google site:ebean-orm.github.io</a>`)
    }
    let outLines = [];
    for (let n = 0; n < lines.length; n++) {
      const line = lines[n];
      let active = (n === 0) ? ' active' : '';
      let google = (line.indexOf('google.com/search') >= 0) ? ' google-search' : '';
      outLines.push(`<li class="${active}${google}">${line}</li>`);
    }
    if (outLines.length === 0) {
      outLines.push('<li>No results found</li>');
    }
    searchResults.html(outLines.join(''));
  }

  $('#searchinput').on('focus', function() {
    //console.log('focus');
    scrollBy(0, -200);
    updateSearchResults();
  }).on('change', function() {
    //console.log('change');
    updateSearchResults();
  }).on('keyup', function(e) {
    //console.log('keyup');
    if ([13, 16, 20, 37, 38, 39, 40, 91].indexOf(e.which) < 0) {
      updateSearchResults();
    }
  });
});


String.prototype.normalizeForSearch = function() {
  return this.toLowerCase().replace(/[\s\/,.;\-]+/g, ' ');
};

String.prototype.escapeHTML = function() {
  return String(this)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
};

Array.prototype.sorted = function(method) {
  let out = this.slice();
  out.sort(method);
  return out;
};

function comparerBy(selector) {
  return function(a, b) {
    let ra = selector(a), rb = selector(b);
    if (ra < rb) return -1;
    if (ra > rb) return +1;
    return 0;
  }
}

function composeComparers(...comparers) {
  return function(a, b) {
    for (const comparer of comparers) {
      const result = comparer(a, b);
      if (result !== 0) return result;
    }
    return 0;
  }
}

