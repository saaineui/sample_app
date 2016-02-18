(function() {
 var direction, anchor;
 anchor = 0;
 
    jQuery(function() {
        jQuery("#book-nav nav").click(function(){
            if (jQuery(this).hasClass("up")) { direction = "+"; anchor++; } else { direction = "-"; anchor--; }
                                      if (anchor <= 0) {
                    jQuery("#ebook").animate({ top: direction + "=82vh" }, 1000);
                                      } else {
                                      anchor = 0;
                                      }
        });
    });
}());