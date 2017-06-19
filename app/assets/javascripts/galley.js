$(document).ready(function() {
     
        $( ".main-text.page" ).each(function( index ) {
            var copy = $( this ).clone();
            $( this ).after( copy );
        });
    
        var page = $(".page").first();
        var page_count = $(".page").length;
        var processed = 0;
    
        while (processed < page_count) {
            var spread = document.createElement('div');
            $("#ebook").append(spread);
            
            left_page = page;
            right_page = page.next();
            page = page.next().next();
            
            $(spread).addClass("spread")
                .append(left_page)
                .append(right_page);
            
            processed += 2;
        }
        

		setTimeout(function(){
		
			/* Get line height */
			var line_height = parseInt( jQuery("#ebook p").css("line-height") );
			
			/* Resize book images */
			$("#ebook figure, #ebook h2").each(function() {
				var box_height = parseInt( $(this).height() ); 
				$(this).height( (box_height - (box_height % line_height) + line_height).toString() + "px" ); 
			});
                    
                }, 500); /* close delay */			

}());