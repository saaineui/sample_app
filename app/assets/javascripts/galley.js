$(document).ready(function() {
    
    PAGES_PER_SIGNATURE = 32;
    var page_height = jQuery(".page").first().height();
    var line_height = parseInt( jQuery("#ebook p").css("line-height") );
    var pages = [];
    var new_page, page_copy;
     
    
    function make_page(page, page_num, pages_before) {
        var signature = Math.ceil(page_num / PAGES_PER_SIGNATURE);
        page.children(".sidebar").text(page_num+" - S"+signature);
        
        return { page: page, page_num: page_num, signature: signature, pages_before: pages_before };
    }
    

    setTimeout(function(){
		
	/* Resize book images */
	$("#ebook figure, #ebook h2").each(function() {
            var box_height = parseInt( $(this).height() ); 
            $(this).height( (box_height - (box_height % line_height) + line_height).toString() + "px" ); 
	});
    
        $( ".page" ).each(function( index ) {
            
            new_page = make_page($( this ), pages.length+1, 0);
            pages.push(new_page);
            
            var content_height = parseInt( $( this ).children(".rendered-text").height() );			
            var total_pages_in_section = Math.ceil(content_height / page_height);
			
            for (pages_before = 1; pages_before < total_pages_in_section; pages_before++) {
                page_copy = $( this ).clone();
			
                page_copy.children(".rendered-text").css("margin-top","-"+(page_height*pages_before)+"px");
                
                new_page = make_page(page_copy, pages.length+1, pages_before);
                pages.push(new_page);
            
            }
            
        });
    
        for (i=0; i<pages.length; i+=2) {
            var spread = document.createElement('div');
            $("#ebook").append(spread);
            
            left_page = pages[i].page;
            right_page = i+1 < pages.length ? pages[i+1].page : null;
            
            $(spread).addClass("spread")
                .addClass("clearfix")
                .append(left_page)
                .append(right_page);
        }
                    
    }, 500); /* close delay */			

}());