$(document).ready(function(spineless) {

    WRAPPER_PADDING = 16;
    SCROLL_WRAP_MARGIN = 16;
    NEXT_BACK_MARGIN = 30;
  
    BookScroll.initialize_data(spineless);
    
    // Lightbox for zooming in on book images
    $("#ebook figure img").click(function(){
        $("#lightbox").css("background-image", "url('" + $(this).attr("src") + "')");
        $("#lightbox").show();
    });
  
    $("#close").click(function(){
        $("#lightbox").hide();
    });

    $(window).load(function() {
        var line_height = BookScroll.get_line_height(); // 1
        var sticky_bar_height = parseInt( $("#sticky-bar > nav").height() ); // 2
        var box_height = $(window).height() - sticky_bar_height - WRAPPER_PADDING - SCROLL_WRAP_MARGIN - NEXT_BACK_MARGIN; // 3
        BookScroll.update('scroll_interval', box_height - (box_height % line_height)); // 4

        // Resize bounding box 
        $('#scroll-wrap').height(BookScroll.data().scroll_interval + 'px');

        // Resize book image containers to align with line height grid 
        $("#ebook figure, #ebook h2").each(function() {
            GalleyImages.align_container.call(this, line_height); 
        });

        BookScroll.update( 'content_height', parseInt($("#ebook").height()) ); // 5
        BookScroll.update_anchor_and_max_clicks(); // 6

        if (BookScroll.is_multipage()) {
            $("#book-nav").fadeTo("slow", 1); // Show buttons if multi-page section
        }

        if (BookScroll.is_prescrolled_page()) {
            BookScroll.prescroll_page();
        } 

        BookScroll.update_progress_bar(); 

        $("#book-nav nav").click(function(){
            BookScroll.scroll_page(BookScroll.get_anchor_increment(this));
        });
    }); // close window load
        
}(spineless));