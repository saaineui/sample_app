(function() {

	var direction, scroll_interval;
	var anchor = 0;
	var margin = 16*4;

	jQuery(function() {
	
		if (document.getElementById('scroll-wrap') != null ) {
		
		
			scroll_interval = jQuery(window).height() - jQuery('header').height() - margin;
			jQuery('#scroll-wrap').height(scroll_interval);

			window.addEventListener("resize", function() {
				/* Reset when window resizes or screen orientation changes */
				scroll_interval = jQuery(window).height() - jQuery('header').height() - margin;
				jQuery('#scroll-wrap').height(scroll_interval);
			});

			jQuery("#book-nav nav").click(function(){
			
				/* Get scroll direction */
				if (jQuery(this).hasClass("up")) { direction = "+"; anchor++; } else { direction = "-"; anchor--; }
				
				if (anchor <= 0) {
					jQuery("#ebook").animate({ top: direction + "=" + scroll_interval + "px" }, 1000);
				} else {
					anchor = 0;
				}
				
			});
		}
		
	});
		
}());