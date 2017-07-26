$(document).ready(function(spineless) {

    spineless.anchor = 0;
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

        var content_height = parseInt( $("#ebook").height() );
        var is_multipage = content_height > spineless.scroll_interval;
        var is_prescrolled_page = spineless.scroll_interval <= content_height * spineless.scroll_as_decimal;
      
        if (content_height % spineless.scroll_interval == 0) { // special handling for full height last page
            spineless.max_clicks = content_height / spineless.scroll_interval - 1;
        } else { 
            spineless.max_clicks = Math.floor(content_height / spineless.scroll_interval);
        }

        if (is_multipage) {
            $("#book-nav").fadeTo("slow", 1); // Show buttons if multi-page section
        }

        if (is_prescrolled_page) {
            spineless.anchor = Math.floor((content_height * spineless.scroll_as_decimal) / spineless.scroll_interval);
            $("#ebook").css("margin-top","-"+(spineless.scroll_interval * spineless.anchor)+"px");
        }
      
        BookScroll.update_progress_bar(spineless);

        $("#book-nav nav").click(function(){
            spineless = BookScroll.scroll_page.call(this, spineless);
        });
    }); // close window load
        
}(spineless));