describe("BookScroll", function() {
  var chapter, short_chapter;

  beforeEach(function() {
    chapter = {
      progress_start: 0,
      section_progress_points: 100, // book has one chapter, so section_progress_points is 100%
      scroll: 0,
      content_height: 100,
      scroll_interval: 20,
      anchor: 0,
      max_clicks: 4,
    };
    BookScroll.initialize_data(chapter);
    
    short_chapter = {
      progress_start: 0,
      section_progress_points: 0, 
      scroll: 0,
      content_height: 10,
      scroll_interval: 20
    }

    // create mock dom
    $('body').append('<div id="wrapper"></div>');
    up_nav_btn = $('<nav/>', { "class": 'up' }).appendTo('#wrapper');
    down_nav_btn = $('<nav/>', { "class": 'down' }).appendTo('#wrapper');
    scroll_wrap_div = $('<div/>', { "id": 'scroll-wrap', "height": 210 }).appendTo('#wrapper');
    ebook_div = $('<div/>', { "id": 'ebook', "height": 1050 }).appendTo('#scroll-wrap');
    progress_div = $('<div/>', { "id": 'progress' }).appendTo('#wrapper');
    progress_percent_div = $('<div/>', { "id": 'progress-percent' }).appendTo('#wrapper');
    get_bookmark_a = $('<a/>', { "id": 'bookmark', "href": '/books/2/4', }).appendTo('#wrapper');

    save_bookmark_a = $('<a/>', {
        "id": 'new-bookmark',
        "href": '/bookmarks/new?book_id=2&location=4&scroll=0',
    }).appendTo('#wrapper');
  });
  
  afterEach(function() {
    $('#wrapper').remove();
  });
  
  it("#initialize_data copies passed object data to private data object", function() {
    expect(BookScroll.data()).toEqual( chapter );
  });
  
  it("#initialize_height_props sets line_height and scroll_interval", function() {
    $('<div/>', { "id": 'sticky-bar' }).appendTo('#wrapper');
    $('<nav/>', { "height": 10 }).appendTo('#sticky-bar');
    BookScroll.initialize_height_props();
    expect(BookScroll.data().scroll_interval).toBeGreaterThan( 0 );
    expect(BookScroll.data().line_height).toEqual( 30 );
  });
  
  it("#update updates data object prop to specified value", function() {
    BookScroll.update('max_clicks', 10)
    expect(BookScroll.data().max_clicks).toEqual( 10 );

    BookScroll.update('arbitrary', true)
    expect(BookScroll.data().arbitrary).toBe( true );
  });
  
  it("#get_line_height retrieves line height from <h2> tag", function() {
    $('<h2 style="line-height: 70px"></h2>').appendTo('#ebook');
    expect(BookScroll.get_line_height()).toEqual( 35 );
  });
  
  it("#get_line_height retrieves line height from <p> tag", function() {
    $('<p style="line-height: 36px"></p>').appendTo('#ebook');
    expect(BookScroll.get_line_height()).toEqual( 36 );
  });
  
  it("#get_sticky_bar_height retrieves sticky bar height from <nav> child of #sticky-bar", function() {
    $('<div/>', { "id": 'sticky-bar' }).appendTo('#wrapper');
    $('<nav/>', { "height": 15 }).appendTo('#sticky-bar');
    expect(BookScroll.get_sticky_bar_height()).toEqual( 15 );
  });
  
  it("#compute_anchor handles short chapter", function() {
    BookScroll.initialize_data(short_chapter);
    expect(BookScroll.compute_anchor()).toEqual( 0 );
  });
  
  it("#compute_anchor outputs zero-indexed page number", function() {
    expect(BookScroll.compute_anchor()).toEqual( 0 );
    
    BookScroll.update('scroll', 20);
    expect(BookScroll.compute_anchor()).toEqual( 1 );

    BookScroll.initialize_data({ scroll: 5, content_height: 1850, scroll_interval: 100 });
    expect(BookScroll.compute_anchor()).toEqual( 1 );

    BookScroll.update('scroll', 84);
    expect(BookScroll.compute_anchor()).toEqual( 16 );
  });

  it("#compute_scroll computes scroll amount from zero index page anchor", function() {
    expect(BookScroll.compute_scroll(BookScroll.data().anchor, BookScroll.data().max_clicks)).toEqual( 0 );
    expect(BookScroll.compute_scroll(1, 18)).toEqual( 5 );
    expect(BookScroll.compute_scroll(16, 18)).toEqual( 84 );
  });
  
  it("#compute_max_clicks handles short chapter", function() {
    BookScroll.initialize_data(short_chapter);
    expect(BookScroll.compute_max_clicks()).toEqual( 0 );
  });
  
  it("#compute_max_clicks tells us number of clicks to traverse section", function() {
    expect(BookScroll.compute_max_clicks()).toEqual( 4 );
    
    BookScroll.update('scroll_interval', 19);
    expect(BookScroll.compute_max_clicks()).toEqual( 5 );
  });
  
  it ("#update_anchor_and_max_clicks updates props with computed vals", function() {
    BookScroll.update('scroll', 20);
    BookScroll.update('content_height', 513);
    BookScroll.update('scroll_interval', 100);
    BookScroll.update_anchor_and_max_clicks();
    expect(BookScroll.data().anchor).toBe( 1 );
    expect(BookScroll.data().max_clicks).toBe( 5 );
  });

  it("#is_multipage tells us if text is taller than box", function() {
    expect(BookScroll.is_multipage()).toBe( true );
    
    BookScroll.update('scroll_interval', 200);
    expect(BookScroll.is_multipage()).toBe( false );
  });

  it("#is_prescrolled_page tells us if anchor is greater than zero", function() {
    expect(BookScroll.is_prescrolled_page()).toBe( false );
    
    BookScroll.update('anchor', 1);
    expect(BookScroll.is_prescrolled_page()).toBe( true );
  });

  it("#get_anchor_increment gets anchor_increment value from nav element", function() {
    expect(BookScroll.get_anchor_increment(down_nav_btn)).toEqual( 1 );
    expect(BookScroll.get_anchor_increment(up_nav_btn)).toEqual( -1 );
  });

  it("#update_progress_bar handles small chapters", function() {
    BookScroll.update('section_progress_points', 0);
    BookScroll.update_progress_bar();
    expect(progress_div.width()).toEqual( 0 );
    expect(progress_percent_div.text()).toEqual( "0%" );
  });

  it("#update_progress_bar updates progress bar to match data object", function() {
    BookScroll.update('anchor', 1);
    var expected_progress_bar_width = progress_div.parent().width() / 5;
    
    BookScroll.update_progress_bar();
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "20%" );
  });

  it("#update_bookmark_links updates bookmark links to match data object", function() {
    BookScroll.update('anchor', 1);
    BookScroll.update_bookmark_links();
    expect(get_bookmark_a.attr("href")).toEqual( '/books/2/4?scroll=20' );
    expect(save_bookmark_a.attr("href")).toEqual( '/bookmarks/new?book_id=2&location=4&scroll=20' );
  });

  it("#scroll_page increments anchor and progress bar", function() {
    BookScroll.scroll_page(BookScroll.get_anchor_increment(down_nav_btn));
    var expected_progress_bar_width = progress_div.parent().width() / 5;
    
    expect(BookScroll.data().anchor).toEqual( 1 );
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "20%" );
    expect(get_bookmark_a.attr("href")).toEqual( '/books/2/4?scroll=20' );
    expect(save_bookmark_a.attr("href")).toEqual( '/bookmarks/new?book_id=2&location=4&scroll=20' );
  });

  it("#scroll_page maxes out at max_clicks", function() {
    for (i=0; i<10; i++) { BookScroll.scroll_page(1); }
    var expected_progress_bar_width = progress_div.parent().width() * 0.8;
    
    expect(BookScroll.data().anchor).toEqual( 4 );
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 2 );
    expect(progress_percent_div.text()).toEqual( "80%" );
  });

  it("#scroll_page maxes out at 0", function() {
    BookScroll.update('anchor', 2);
    for (i=0; i<10; i++) { BookScroll.scroll_page(-1); }
    expect(BookScroll.data().anchor).toEqual( 0 );
    expect(progress_div.width()).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "0%" );
  });

  it("#prescroll_page adjusts ebook margin", function() {
    BookScroll.update('anchor', 1);
    BookScroll.prescroll_page();
    expect(ebook_div.css("margin-top")).toEqual( "-20px" );
  });
});
