$(document).ready(function(spineless) {

    WRAPPER_PADDING = 16;
    SCROLL_WRAP_MARGIN = 16;
    NEXT_BACK_MARGIN = 30;
    
    // Lightbox for zooming in on book images
    $("#ebook figure img").click(function(){
        $("#lightbox").css("background-image", "url('" + $(this).attr("src") + "')");
        $("#lightbox").show();
    });
  
    $("#close").click(function(){
        $("#lightbox").hide();
    });

    $(window).load(function() {
        var line_height = parseInt( $("#ebook p").css("line-height") );
        var sticky_bar_height = parseInt( $("#sticky-bar > nav").height() );
        var box_height = $(window).height() - sticky_bar_height - WRAPPER_PADDING - SCROLL_WRAP_MARGIN - NEXT_BACK_MARGIN;
        spineless.scroll_interval = box_height - (box_height % line_height);

        // Resize bounding box 
        $('#scroll-wrap').height(spineless.scroll_interval + 'px');

        // Resize book image containers to align with line height grid 
        $("#ebook figure, #ebook h2").each(function() {
            GalleyImages.align_container.call(this, line_height); 
        });

        spineless.content_height = parseInt( $("#ebook").height() );
        spineless.anchor = BookScroll.compute_anchor(spineless);
        spineless.max_clicks = BookScroll.compute_max_clicks(spineless);

        if (BookScroll.is_multipage(spineless)) {
            $("#book-nav").fadeTo("slow", 1); // Show buttons if multi-page section
        }

        if (BookScroll.is_prescrolled_page(spineless)) {
            BookScroll.prescroll_page(spineless);
        } 

        BookScroll.update_progress_bar(spineless); 

        $("#book-nav nav").click(function(){
            spineless = BookScroll.scroll_page(BookScroll.get_anchor_increment(this), spineless);
        });
    }); // close window load
        
}(spineless));