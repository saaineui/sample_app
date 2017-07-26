describe("BookScroll", function() {
  var spineless, expected_spineless;

  beforeEach(function() {
    spineless = {
      progress_start: 0,
      progress_with_scroll: 0,
      slice_length: 100, // book has one chapter, so slice_length is 100%
      scroll_as_decimal: 0.0,
      anchor: 0,
      max_clicks: 4
    };
    
    expected_spineless = Object.assign({}, spineless);

    $('body').append('<div id="wrapper"></div>');
    
    up_nav_btn = $('<nav/>', {
        "class": 'up'
    }).appendTo('#wrapper');
    
    down_nav_btn = $('<nav/>', {
        "class": 'down'
    }).appendTo('#wrapper');
    
    scroll_wrap_div = $('<div/>', {
        "id": 'scroll-wrap',
        "height": 210
    }).appendTo('#wrapper');

    ebook_div = $('<div/>', {
        "id": 'ebook',
        "height": 1050
    }).appendTo('#scroll-wrap');

    progress_div = $('<div/>', {
        "id": 'progress',
    }).appendTo('#wrapper');

    progress_percent_div = $('<div/>', {
        "id": 'progress-percent',
    }).appendTo('#wrapper');

    get_bookmark_a = $('<a/>', {
        "id": 'bookmark',
        "href": '/books/2/4',
    }).appendTo('#wrapper');

    save_bookmark_a = $('<a/>', {
        "id": 'new-bookmark',
        "href": '/bookmarks/new?book_id=2&location=4&scroll=0',
    }).appendTo('#wrapper');
  });
  
  afterEach(function() {
    $('#wrapper').remove();
  });
  
  it("#get_direction should determine scroll direction from nav element", function() {
    expect(BookScroll.get_direction(down_nav_btn)).toEqual( "-" );
    expect(BookScroll.get_direction(up_nav_btn)).toEqual( "+" );
  });

  it("#update_progress_bar should update progress bar to match data object", function() {
    spineless.anchor++;
    var expected_progress_bar_width = progress_div.parent().width() / 4;
    
    BookScroll.update_progress_bar(spineless);
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "25%" );
  });

  it("#update_bookmark_links should update bookmark links to match data object", function() {
    spineless.anchor++;
    
    BookScroll.update_bookmark_links(spineless);
    expect(get_bookmark_a.attr("href")).toEqual( '/books/2/4?scroll=25' );
    expect(save_bookmark_a.attr("href")).toEqual( '/bookmarks/new?book_id=2&location=4&scroll=25' );
  });

  it("#scroll_page should increment anchor and progress bar", function() {
    spineless = BookScroll.scroll_page(BookScroll.get_direction(down_nav_btn), spineless);
    expected_spineless.anchor++;
    var expected_progress_bar_width = progress_div.parent().width() / 4;
    
    expect(spineless).toEqual( expected_spineless );
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "25%" );
    expect(get_bookmark_a.attr("href")).toEqual( '/books/2/4?scroll=25' );
    expect(save_bookmark_a.attr("href")).toEqual( '/bookmarks/new?book_id=2&location=4&scroll=25' );
  });

  it("#scroll_page should max out at max_clicks", function() {
    for (i=0; i<10; i++) {
      spineless = BookScroll.scroll_page("-", spineless);
    }
    expected_spineless.anchor = 4;
    var expected_progress_bar_width = progress_div.parent().width();
    
    expect(spineless).toEqual( expected_spineless );
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "100%" );
  });

  it("#scroll_page should max out at 0", function() {
    spineless.anchor = 2;
    for (i=0; i<10; i++) {
      spineless = BookScroll.scroll_page("+", spineless);
    }
    expected_spineless.anchor = 0;
    expect(spineless).toEqual( expected_spineless );
    expect(progress_div.width()).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "0%" );
  });
});
