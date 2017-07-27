$(document).ready(function() {
    
    PAGES_PER_PRINT_PAGE = 4;
    var print_pages_per_signature = 8;
    var pages_per_signature = PAGES_PER_PRINT_PAGE * print_pages_per_signature;
    var page_height = parseInt( $(".page").first().height() );
    var line_height = parseInt( $("#ebook p").css("line-height") );
    var page_positions = ["FL","FR","BL","BR"];
  
    $('#page_height').val( page_height );
    $('#line_height').val( line_height );
    $("#pages").val(JSON.stringify([]));
    $("#images").val(JSON.stringify([]));
    
    function make_image(src, height, margin_top, margin_bottom, section_order, n, levels_in) {
        var new_image = { 
            src: src, height: height, margin_top: margin_top, margin_bottom: margin_bottom, 
            section_order: section_order, n: n, levels_in: levels_in
        };
        
        // add to hidden input for printing
        add_to_images_form_array(new_image);
        
        return new_image;
    }
  
    function add_to_images_form_array(image) {
        var images = JSON.parse($("#images").val());
        images.push(image);
        $("#images").val(JSON.stringify(images));
    }
    
    /* 
     * page_position is order in which to render pages to print a page, front before back, left then right:
     * front left (FL = 0), front right (FR = 1), back left (BL = 2), back right (BR = 3)
     * page_position is 0 indexed, and signature, page_num, and signature_order are 1 indexed.
     */    
    
    function make_page(page, page_num, pages_before) {
        var page_meta = get_page_meta(page_num);        
        var new_page = { 
                page: page, order: page.attr("data-order"), page_num: page_num, pages_before: pages_before, 
                signature: page_meta.signature, signature_order: page_meta.signature_order, 
                page_position: page_meta.page_position 
            };
        
        // print metadata in sidebar
        if (page) { new_page.page.children(".sidebar").text(get_sidebar_string(new_page)) };
        
        // add to hidden input for printing
        add_to_pages_form_array(new_page);
        
        return new_page;
    }
    
    function blank_page_div() {
        var page = document.createElement('div');
        $(page).addClass("page")
               .attr("data-order", "blank")
               .append('<div class="sidebar"></div>');
        
        return page;
    }
    
    function add_to_pages_form_array(page) {
        var pages = JSON.parse($("#pages").val());
        pages.push(page);
        $("#pages").val(JSON.stringify(pages));
    }
    
    function get_page_meta(page_num) {
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
        
        return { signature: signature, signature_order: signature_order, page_position: page_position, is_on_right: is_on_right(page_position) };
    }
        
    function get_sidebar_string(page) {
        return "S"+page.signature+"-So"+page.signature_order+"-"+page_positions[page.page_position]+"---"+page.page_num;
    }
    
    function is_on_right(page_position) {
        // new sections must start on the right-hand side
        return page_position == 1 || page_position == 3;
    }
    
    // wait for book text and images to render before resizing/reordering
    $(window).load(function() {
      
        var page_copy, new_page;
        var page_num = 1;
        var pages = [];
        
        $( ".page" ).each(function( index ) {
            $(this).find("img").each(function( n ){
                var height = GalleyImages.shrink_to_print_size.call(this); // print resolution
                var levels_in = $(this).parent().parent().hasClass('page') ? 2 : 3;
                GalleyImages.align_image.call(this, line_height, page_height);
                make_image($(this).attr('src'), height, $(this).css("margin-top"), $(this).css("margin-bottom"), index, n, levels_in);
            });
        
            // new section: create blank pages until slot is on right
            while (!get_page_meta(page_num).is_on_right) {
                pages.push(make_page($( blank_page_div() ), page_num, 0));
                page_num += 1;
            }
            
            pages.push(make_page($( this ), page_num, 0));
            page_num += 1;
            
            var content_height = parseInt( $( this ).children(".rendered-text").height() );			
            var total_pages_in_section = Math.ceil(content_height / page_height);
			
            for (pages_before = 1; pages_before < total_pages_in_section; pages_before++) {
                page_copy = $( this ).clone();
			
                // move page into position
                page_copy.children(".rendered-text").css("margin-top","-"+(page_height*pages_before)+"px");
                
                pages.push(make_page(page_copy, page_num, pages_before));  
                page_num += 1;
            }
            
            $( this ).remove();
        });
        
        // Fill out any empty slots in final signature with blank pages
        var last_page_num = get_page_meta(page_num).signature*pages_per_signature;
        
        for (pn = page_num; pn <= last_page_num; pn++) {
                new_page = make_page($( blank_page_div() ), pn, 0);
                pages.push(new_page);
        }
        
        // Add to DOM for human review
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
        
        $("#print-submit").removeAttr("disabled");
                    
    }); 			

}());