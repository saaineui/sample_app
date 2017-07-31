describe("BookScroll", function() {
  var spineless, expected_spineless, short_page;

  beforeEach(function() {
    spineless = {
      progress_start: 0,
      section_progress_points: 100, // book has one chapter, so section_progress_points is 100%
      scroll: 0,
      anchor: 0,
      max_clicks: 4,
      content_height: 100,
      scroll_interval: 20
    };
    
    expected_spineless = Object.assign({}, spineless);

    short_page = {
      progress_start: 0,
      section_progress_points: 0, // book has one chapter, so section_progress_points is 100%
      scroll: 0,
      content_height: 10,
      scroll_interval: 20
    }

    BookScroll.initialize_data(spineless);
    
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
  
  it("#get_line_height retrieves hard-coded line height without css match", function() {
    expect(BookScroll.get_line_height()).toEqual( 30 );
  });
  
  it("#get_line_height retrieves line height from <h2> tag", function() {
    $('<h2 style="line-height: 70px"></h2>').appendTo('#ebook');
    expect(BookScroll.get_line_height()).toEqual( 35 );
  });
  
  it("#get_line_height retrieves line height from <p> tag", function() {
    $('<p style="line-height: 36px"></p>').appendTo('#ebook');
    expect(BookScroll.get_line_height()).toEqual( 36 );
  });
  
  it("#compute_anchor handles short page", function() {
    BookScroll.initialize_data(short_page);
    expect(BookScroll.compute_anchor()).toEqual( 0 );
  });
  
  it("#compute_anchor should output zero-indexed page number", function() {
    expect(BookScroll.compute_anchor()).toEqual( 0 );
    
    BookScroll.update('scroll', 20);
    expect(BookScroll.compute_anchor()).toEqual( 1 );

    var math_fake = {
      scroll: 5,
      content_height: 1850,
      scroll_interval: 100
    };
    BookScroll.initialize_data(math_fake);
    expect(BookScroll.compute_anchor()).toEqual( 1 );

    BookScroll.update('scroll', 84);
    expect(BookScroll.compute_anchor()).toEqual( 16 );
  });

  it("#compute_scroll computes scroll amount from zero index page anchor", function() {
    expect(BookScroll.compute_scroll()).toEqual( 0 );

    var math_fake = {
      anchor: 1,
      max_clicks: 18
    };
    BookScroll.initialize_data(math_fake);
    expect(BookScroll.compute_scroll()).toEqual( 5 );
    
    BookScroll.update('anchor', 16);
    expect(BookScroll.compute_scroll()).toEqual( 84 );
  });
  
  it("#compute_max_clicks handles short page", function() {
    BookScroll.initialize_data(short_page);
    expect(BookScroll.compute_max_clicks()).toEqual( 0 );
  });
  
  it("#compute_max_clicks should output upper bound for scroll", function() {
    expect(BookScroll.compute_max_clicks()).toEqual( 4 );
    
    BookScroll.update('scroll_interval', 19);
    expect(BookScroll.compute_max_clicks()).toEqual( 5 );
  });
  
  it ("#update_anchor_and_max_clicks should update props with computed vals", function() {
    BookScroll.update('scroll', 20);
    BookScroll.update('content_height', 513);
    BookScroll.update('scroll_interval', 100);
    BookScroll.update_anchor_and_max_clicks();
    expect(BookScroll.data().anchor).toBe( 1 );
    expect(BookScroll.data().max_clicks).toBe( 5 );
  });

  it("#is_multipage should return true if text is taller than box", function() {
    expect(BookScroll.is_multipage()).toBe( true );
    
    BookScroll.update('scroll_interval', 200);
    expect(BookScroll.is_multipage()).toBe( false );
  });

  it("#is_prescrolled_page should return true if anchor is greater than zero", function() {
    expect(BookScroll.is_prescrolled_page()).toBe( false );
    
    BookScroll.update('anchor', 1);
    expect(BookScroll.is_prescrolled_page()).toBe( true );
  });

  it("#get_anchor_increment should determine anchor_increment from nav element", function() {
    expect(BookScroll.get_anchor_increment(down_nav_btn)).toEqual( 1 );
    expect(BookScroll.get_anchor_increment(up_nav_btn)).toEqual( -1 );
  });

  it("#update_progress_bar handles small chapters", function() {
    BookScroll.update('section_progress_points', 0);
    BookScroll.update_progress_bar();
    expect(progress_div.width()).toEqual( 0 );
    expect(progress_percent_div.text()).toEqual( "0%" );
  });

  it("#update_progress_bar should update progress bar to match data object", function() {
    BookScroll.update('anchor', 1);
    var expected_progress_bar_width = progress_div.parent().width() / 5;
    
    BookScroll.update_progress_bar();
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "20%" );
  });

  it("#update_bookmark_links should update bookmark links to match data object", function() {
    BookScroll.update('anchor', 1);
    BookScroll.update_bookmark_links();
    expect(get_bookmark_a.attr("href")).toEqual( '/books/2/4?scroll=20' );
    expect(save_bookmark_a.attr("href")).toEqual( '/bookmarks/new?book_id=2&location=4&scroll=20' );
  });

  it("#scroll_page should increment anchor and progress bar", function() {
    BookScroll.scroll_page(BookScroll.get_anchor_increment(down_nav_btn));
    var expected_progress_bar_width = progress_div.parent().width() / 5;
    
    expect(BookScroll.data().anchor).toEqual( 1 );
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "20%" );
    expect(get_bookmark_a.attr("href")).toEqual( '/books/2/4?scroll=20' );
    expect(save_bookmark_a.attr("href")).toEqual( '/bookmarks/new?book_id=2&location=4&scroll=20' );
  });

  it("#scroll_page should max out at max_clicks", function() {
    for (i=0; i<10; i++) {
      BookScroll.scroll_page(1);
    }
    var expected_progress_bar_width = progress_div.parent().width() * 0.8;
    
    expect(BookScroll.data().anchor).toEqual( 4 );
    expect(Math.abs(progress_div.width() - expected_progress_bar_width)).toBeLessThan( 2 );
    expect(progress_percent_div.text()).toEqual( "80%" );
  });

  it("#scroll_page should max out at 0", function() {
    BookScroll.update('anchor', 2);
    for (i=0; i<10; i++) {
      BookScroll.scroll_page(-1);
    }
    expect(BookScroll.data().anchor).toEqual( 0 );
    expect(progress_div.width()).toBeLessThan( 1 );
    expect(progress_percent_div.text()).toEqual( "0%" );
  });

  it("#prescroll_page should adjust ebook margin", function() {
    BookScroll.update('anchor', 1);
    BookScroll.prescroll_page();
    expect(ebook_div.css("margin-top")).toEqual( "-20px" );
  });
});
