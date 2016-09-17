	jQuery(document).ready(function() {

		/* Toggle menus */
		jQuery("div.nav-wrapper > ul > li").click(function(){
			jQuery(this).next().children("ul.menu").hide();
			jQuery(this).next().removeClass("open");
			jQuery(this).prev().children("ul.menu").hide();
			jQuery(this).prev().removeClass("open");
			jQuery(this).children("ul.menu").toggle();
			jQuery(this).toggleClass("open");
		});
		
	});