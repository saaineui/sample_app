$(document).ready(function() {
    
    PAGES_PER_PRINT_PAGE = 4;
    var print_pages_per_signature = 8;
    var pages_per_signature = PAGES_PER_PRINT_PAGE * print_pages_per_signature;
    var page_height = parseInt( $(".page").first().height() );
    var line_height = parseInt( $("#ebook p").css("line-height") );
    var page_copy, new_page;
    var page_positions = ["FL","FR","BL","BR"];
    var page_num = 1;
    
    var view_type = $("body").hasClass("front") ? "F" : "P";
    if ($("body").hasClass("back")) { view_type = "B"; }
    var is_filtered_view = view_type !== "P";
    var array_increment_size = pages_per_signature / 2;
    
    /* 
     * page_position is order in which to render pages to print a page, front before back, left then right:
     * front left (FL = 0), front right (FR = 1), back left (BL = 2), back right (BR = 3)
     * page_position is 0 indexed, and signature, page_num, and signature_order are 1 indexed.
     */    
    
    function make_page(page, page_num, pages_before) {
        var page_meta = get_page_meta(page_num);        
        var new_page = { 
                page: page, page_num: page_num, pages_before: pages_before, 
                signature: page_meta.signature, signature_order: page_meta.signature_order, 
                page_position: page_meta.page_position 
            };
        
        // print metadata in sidebar
        if (page) { new_page.page.children(".sidebar").text(get_sidebar_string(new_page)) };
        
        return new_page;
    }
    
    function blank_page_div() {
        var page = document.createElement('div');
        $(page).addClass("page")
               .append('<div class="sidebar"></div>');
        
        return page;
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
    
    function is_out_of_bounds(el, box_height) {
        var box_bottom = Math.ceil(parseInt( el.position().top ) / box_height) * box_height;
        return position_bottom(el) > box_bottom;
    }
            
    function move_to_next(el, box_height) {
        var visible_height_of_el = el.height() - (position_bottom(el) % box_height);
        el.css("margin-top", visible_height_of_el.toString() + "px");
    }
            
    function position_bottom(el) {
        return parseInt( el.position().top ) + parseInt( el.height() );
    }
    
    // filtered view (front or back) helpers
    
    function include_page(view_type, page_position) {
        return page_positions[page_position][0] == view_type;
    }
    
    function resize_array_and_add(array, item, i) {
        if (i >= array.length) {
            array = array.concat(Array(array_increment_size));
        }
        
        array[i] = item;
        
        return array;
    }

    function get_render_index(page) {
        pages_per_side = PAGES_PER_PRINT_PAGE / 2;
        side_agnostic_page_position = page.page_position % 2;
        return (page.signature - 1)*array_increment_size + (page.signature_order - 1)*pages_per_side + side_agnostic_page_position;
    }
    
    
    
    // wait for book text and images to render before resizing/reordering
    $(window).load(function() {		
            
	// resize book images down for better print resolution
	$("#ebook img").each(function() {
            var img_width = parseInt( $(this).width() ); 
            $(this).width( (img_width*0.75).toString() + "px" ); 
	});
    
        // line up image containers along grid and in bounds
	$("#ebook figure, #ebook h2").each(function() {
            var box_height = parseInt( $(this).height() ); 
            $(this).height( (box_height - (box_height % line_height) + line_height).toString() + "px" ); 
            if (is_out_of_bounds($(this), page_height)) { move_to_next($(this), page_height); }
	});

        var pages = is_filtered_view ? Array(array_increment_size) : [];
        
        $( ".page" ).each(function( index ) {
            // new section: create blank pages until slot is on right
            while (!get_page_meta(page_num).is_on_right) {
                if (!is_filtered_view) {
                    pages.push(make_page($( blank_page_div() ), page_num, 0));
                } else if (include_page(view_type, get_page_meta(page_num).page_position)) {
                    new_page = make_page($( blank_page_div() ), page_num, 0);
                    pages = resize_array_and_add(pages, new_page, get_render_index(new_page));
                }
                page_num += 1;
            }
    
            
            if (!is_filtered_view) {
                pages.push(make_page($( this ), page_num, 0));
            } else if (include_page(view_type, get_page_meta(page_num).page_position)) {
                new_page = make_page($( this ), page_num, 0);
                pages = resize_array_and_add(pages, new_page, get_render_index(new_page));
            }
            page_num += 1;
            
            var content_height = parseInt( $( this ).children(".rendered-text").height() );			
            var total_pages_in_section = Math.ceil(content_height / page_height);
			
            for (pages_before = 1; pages_before < total_pages_in_section; pages_before++) {
                page_copy = $( this ).clone();
			
                // move page into position
                page_copy.children(".rendered-text").css("margin-top","-"+(page_height*pages_before)+"px");
                
                if (!is_filtered_view) {
                    pages.push(make_page(page_copy, page_num, pages_before));  
                } else if (include_page(view_type, get_page_meta(page_num).page_position)) {
                    new_page = make_page(page_copy, page_num, pages_before);
                    pages = resize_array_and_add(pages, new_page, get_render_index(new_page));
                }
                page_num += 1;
            }
            
            $( this ).remove();
        });
        
        var last_page_num = get_page_meta(page_num).signature*pages_per_signature;
        
        // Fill out empty rows with blank pages
        for (pn = page_num; pn <= last_page_num; pn++) {
            if (include_page(view_type, get_page_meta(pn).page_position)) {
                new_page = make_page($( blank_page_div() ), pn, 0);
                pages[get_render_index(new_page)] = new_page;
            }
        }
            
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
                    
    }); 			

}());