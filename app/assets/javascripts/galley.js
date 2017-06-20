$(document).ready(function() {
    
    PAGES_PER_PRINT_PAGE = 4;
    var print_pages_per_signature = 8;
    var pages_per_signature = PAGES_PER_PRINT_PAGE * print_pages_per_signature;
    var page_height = jQuery(".page").first().height();
    var line_height = parseInt( jQuery("#ebook p").css("line-height") );
    var pages = [];
    var page_copy;
    var page_positions = ["FL","FR","BL","BR"];
    
    /* 
     * page_position is order in which to render pages to print a page, front before back, left then right:
     * front left (FL = 0), front right (FR = 1), back left (BL = 2), back right (BR = 3)
     * page_position is 0 indexed, and signature, page_num, and signature_order are 1 indexed.
     */
     
    
    function make_page(page, page_num, pages_before) {
        var page_meta = calculate_page_meta(page_num);        
        var new_page = { 
                page: page, page_num: page_num, pages_before: pages_before, 
                signature: page_meta.signature, signature_order: page_meta.signature_order, 
                page_position: page_meta.page_position 
            };
        
        new_page.page.children(".sidebar").text(get_sidebar_string(new_page));
        
        return new_page;
    }
    
    function calculate_page_meta(page_num) {
        var signature = Math.ceil(page_num / pages_per_signature);
        var offset_page_num = page_num - ((signature-1) * pages_per_signature);
        var page_position, signature_order;
        
        if (offset_page_num > (pages_per_signature / 2)) {
            signature_order = Math.floor((pages_per_signature - offset_page_num)/2)+1;
            page_position = page_num % 2 == 0 ? 0 : 3;
        } else {
            signature_order = Math.ceil(offset_page_num/2);
            page_position = page_num % 2 == 0 ? 2 : 1;
        }
        
        return { signature: signature, signature_order: signature_order, page_position: page_position }
    }
        
    function get_sidebar_string(page) {
        return "S"+page.signature+"-So"+page.signature_order+"-"+page_positions[page.page_position]+"---"+page.page_num;
    }
    
    function is_on_right(page_position) {
        // new sections must start on the right-hand side
        return page_position == 1 || page_position == 3
    }

    setTimeout(function(){
		
	// resize book images 
	$("#ebook img").each(function() {
            var img_width = parseInt( $(this).width() ); 
            $(this).width( (img_width*0.75).toString() + "px" ); 
	});
    
	$("#ebook figure, #ebook h2").each(function() {
            var box_height = parseInt( $(this).height() ); 
            $(this).height( (box_height - (box_height % line_height) + line_height).toString() + "px" ); 
	});
    
        $( ".page" ).each(function( index ) {
            
            pages.push(make_page($( this ), pages.length+1, 0));
            
            var content_height = parseInt( $( this ).children(".rendered-text").height() );			
            var total_pages_in_section = Math.ceil(content_height / page_height);
			
            for (pages_before = 1; pages_before < total_pages_in_section; pages_before++) {
                page_copy = $( this ).clone();
			
                // move page into position
                page_copy.children(".rendered-text").css("margin-top","-"+(page_height*pages_before)+"px");
                
                pages.push(make_page(page_copy, pages.length+1, pages_before));
            
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