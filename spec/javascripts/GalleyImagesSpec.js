describe("GalleyImages", function() {
  var book_text, book_image_container, book_image, line_height, page_height;

  beforeEach(function() {
    $('body').addClass('preview')
      .append('<div id="wrapper"><div id="ebook"><p></p><div class="spread"><div class="page"><div id="rendered-text" class="rendered-text"></div></div></div></div></div>');

    line_height = parseInt( $('#ebook p').first().css('line-height') );

    book_text = $('<div/>', {
        "class": 'fake-textbox',
    }).appendTo('#rendered-text');

    book_image_container = $('<figure/>', {
        "class": 'fake-figure',
    }).appendTo('#rendered-text');

    book_image = $('<img/>', {
        "class": 'fake-image',
        "src": 'app/assets/images/snake_bg.png'
    }).appendTo('.fake-figure');
  });
  
  afterEach(function() {
    $('#wrapper').remove();
  });
  
  it("#shrink_to_print_size should resize image to 75%", function() {
    $('#ebook img').each(GalleyImages.shrink_to_print_size);
    expect(book_image.height()).toEqual( 75 );
  });

  it("#align_image should pad image bottom and move cutoff image to next page", function() {
    page_height = $('.page').first().height();
    
	  $("#ebook img").each(function(){ 
        GalleyImages.align_image.call(this, line_height, page_height); 
    });
    expect(book_image.css("margin-top")).toEqual( '43px' );
    expect(book_image.css("margin-bottom")).toEqual( '16px' );
  });

  it("#align_container should align figure and h2 elements on grid", function() {
	  $("#ebook figure, #ebook h2").each(function(){ 
        GalleyImages.align_container.call(this, line_height); 
    });
    expect(book_image_container.height()).toEqual( 105 );
  });
});
