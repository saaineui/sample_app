 /* 
  * GalleyImages 
  * ============
  * small package for reflowing images off of line breaks in a book 
  * bundled in application.js 
  */
        var GalleyImages = (function() {

            function is_out_of_bounds(image_container, box_height) {
                var box_bottom = Math.ceil(parseInt( $(image_container).position().top ) / box_height) * box_height;
                return position_bottom(image_container) > box_bottom;
            }

            function move_to_next(image_container, box_height) {
                var visible_height_of_el = $(image_container).height() - (position_bottom(image_container) % box_height);
                $(image_container).css("margin-top", visible_height_of_el.toString() + "px");
            }

            function position_bottom(image_container) {
                return parseInt( $(image_container).position().top ) + parseInt( $(image_container).height() );
            }

            function align_container(image_container, line_height) {
                var container_height = parseInt( $(image_container).height() ); 
                $(image_container).height( (container_height - (container_height % line_height) + line_height).toString() + "px" ); 
            }

            return {

                // resize book images down for better print resolution
                shrink_to_print_size: function() {
                    var img_width = parseInt( $(this).width() ); 
                    $(this).width( (img_width*0.75).toString() + "px" ); 
                },
              
                // grow image container height to align with line height grid
                align_container: function(line_height) {
                    align_container(this, line_height); 
                },

                // line up image containers along grid and in bounds
                move_in_bounds: function(line_height, page_height) {
                    align_container(this, line_height); 
                    
                    if (is_out_of_bounds(this, page_height)) { 
                        move_to_next(this, page_height); 
                    }
                }
            };
        })();
