describe("BookScroll", function() {
  var spineless, expected_spineless;

  beforeEach(function() {
    spineless = {
      progress_start: 0,
      section_progress_points: 100, // book has one chapter, so section_progress_points is 100%
      scroll_as_decimal: 0.0,
      anchor: 0,
      max_clicks: 4,
      content_height: 100,
      scroll_interval: 20
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
  
  it("#compute_anchor should output zero-indexed page number", function() {
    expect(BookScroll.compute_anchor(spineless)).toEqual( 0 );
    
    var prescrolled_chapter = {
      scroll_as_decimal: 0.2, 
      content_height: 100,
      scroll_interval: 20
    }
    
    expect(BookScroll.compute_anchor(prescrolled_chapter)).toEqual( 1 );
  });

  it("#compute_max_clicks should output upper bound for scroll", function() {
    expect(BookScroll.compute_max_clicks(spineless)).toEqual( 4 );
    
    spineless.scroll_interval = 19
    expect(BookScroll.compute_max_clicks(spineless)).toEqual( 5 );
  });

  it("#is_multipage should return true if text is taller than box", function() {
    expect(BookScroll.is_multipage(spineless)).toBe( true );
    
    spineless.scroll_interval = 200
    expect(BookScroll.is_multipage(spineless)).toBe( false );
  });

  it("#is_prescrolled_page should return true if anchor is greater than zero", function() {
    expect(BookScroll.is_prescrolled_page(spineless)).toBe( false );
    
    spineless.scroll_as_decimal = 0.2
    expect(BookScroll.is_prescrolled_page(spineless)).toBe( true );
  });

  it("#get_direction should determine scroll direction from nav element", function() {
    expect(BookScroll.get_direction(down_nav_btn)).toEqual( 1 );
    expect(BookScroll.get_direction(up_nav_btn)).toEqual( -1 );
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
      spineless = BookScroll.scroll_page(1, spineless);
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
      spineless = BookScroll.scroll_page(-1, spineless);
    }
    expected_spineless.anchor = 0;
    expect(spineless).toEqual( expected_spineless );
    expect(progress_div.width()).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "0%" );
  });

  it("#prescroll_page should increment ebook margin", function() {
    spineless.anchor = 1;
    BookScroll.prescroll_page(spineless);
    expect(ebook_div.css("margin-top")).toEqual( "-20px" );
  });
});
