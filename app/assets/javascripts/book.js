$(document).ready(function(spineless) {

    var direction, scroll_interval, margin, sticky_bar_height, box_height, bookmark, new_bookmark;
    var anchor = 0;
    var max_clicks = 0;
    var progress_percent = spineless.progress_with_scroll + "%";
    
    /* Open and close lightbox */
    $("#ebook figure img").click(function(){
            $("#lightbox").css("background-image", "url('" + $(this).attr("src") + "')");
            $("#lightbox").show();
    });
    $("#close").click(function(){
            $("#lightbox").hide();
    });

    $("#progress").css("width",spineless.progress_with_scroll+"%");
    
    if (document.getElementById('scroll-wrap') != null ) {
        $(window).load(function() {
        
            /* Get line height */
            var line_height = parseInt( $("#ebook p").css("line-height") );
            
            /* Resize book images */
            $("#ebook figure, #ebook h2").each(function() {
                box_height = parseInt( $(this).height() ); 
                $(this).height( (box_height - (box_height % line_height) + line_height).toString() + "px" ); 
            });
            
            /* Get sticky bar and content box heights */
            sticky_bar_height = parseInt( $("#sticky-bar > nav").height() );
            content_height = parseInt( $("#ebook").height() );
            
            /* Compute scroll interval (16 is wrapper padding, 16 is scroll-wrap top margin, 27 is next/back links) */
            var box_height = $(window).height() - sticky_bar_height - 16 - 16 - 30;
            scroll_interval = box_height - (box_height % line_height);
            
            if (content_height > scroll_interval) {
                
                /* Show buttons if not one page section */
                $("#book-nav").fadeTo("slow",1);
            
                /* Calculate Max Clicks */
                max_clicks = (content_height % scroll_interval == 0) ? ((content_height / scroll_interval) - 1) : Math.floor(content_height / scroll_interval); 

            }
            
            /* Resize bounding box */
            $('#scroll-wrap').height(scroll_interval + 'px');
            
            /* Scroll to bookmark position */
            if (scroll_interval <= (content_height*spineless.scroll_as_decimal)) {
                anchor = Math.floor((content_height*spineless.scroll_as_decimal)/scroll_interval);
                $("#ebook").css("margin-top","-"+(scroll_interval*anchor)+"px");
            }

            /* Scroll exactly one page up or down and then increment progress bar and bookmark link */
            $("#book-nav nav").click(function(){
            
                /* Get scroll direction and increment anchor */
                if ($(this).hasClass("up")) { direction = "+"; anchor--; } else { direction = "-"; anchor++; }
                
                
                if (anchor >= 0) {
                    if (anchor <= max_clicks) {
                        /* Scroll Page */
                        $("#ebook").animate({ marginTop: direction + "=" + scroll_interval + "px" }, 700);
                        
                        /* Progress Bar */
                        spineless.progress_percent = Math.floor(anchor * spineless.slice_length / (max_clicks+1)) + spineless.progress_start + "%";
                        $("#progress").css("width",spineless.progress_percent);
                        $("#progress-percent").text(spineless.progress_percent);
                        
                        /* Bookmark Links */
                        scroll_param = "scroll=" + Math.floor((anchor+1) * 100/(max_clicks+1));
                        
                        bookmark = $("#bookmark").attr("href").replace(/\?scroll=[0-9|.]*/,"")+"?"+scroll_param;
                        $("#bookmark").attr("href", bookmark);
                        
                        if (document.getElementById("new-bookmark") != null) {
                            new_bookmark = $("#new-bookmark").attr("href").replace(/scroll=[0-9|.]*/,scroll_param);
                            $("#new-bookmark").attr("href", new_bookmark);
                        }
                    } else {
                        anchor = max_clicks;
                    }
                } else {
                    anchor = 0;
                }
                
                
            });
       }); // close window load
    } // close if 
        
        
}(spineless));