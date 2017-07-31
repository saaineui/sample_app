$(document).ready(function(spineless) {

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
        initialize_height_props(); // 1
      
        // Resize bounding box 
        $('#scroll-wrap').height(BookScroll.data().scroll_interval + 'px'); // 2

        // Resize book image containers to align with line height grid 
        $("#ebook figure, #ebook h2").each(function() {
            GalleyImages.align_container.call(this, BookScroll.data().line_height); 
        }); 

        BookScroll.update( 'content_height', parseInt($("#ebook").height()) ); // 3
        BookScroll.update_anchor_and_max_clicks(); // 4

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
