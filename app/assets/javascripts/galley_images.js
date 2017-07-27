 /* 
  * GalleyImages 
  * ============
  * small package for reflowing images off of line breaks in a book 
  * bundled in application.js 
  */
        var GalleyImages = (function() {

            function pad_image_bottom(image_el, line_height) {
                var margin_bottom = line_height - ($(image_el).height() % line_height);
                $(image_el).css("margin-bottom", margin_bottom.toString() + "px");
            }

            function is_out_of_bounds(image_el, box_height) {
                var box_bottom = Math.ceil(parseInt( $(image_el).position().top ) / box_height) * box_height;
                return position_bottom(image_el) > box_bottom;
            }

            function move_to_next(image_el, box_height) {
                var visible_height_of_el = $(image_el).height() - (position_bottom(image_el) % box_height);
                $(image_el).css("margin-top", visible_height_of_el.toString() + "px");
            }

            function position_bottom(image_el) {
                return parseInt( $(image_el).position().top ) + parseInt( $(image_el).height() );
            }

            function align_container(image_container, line_height) {
                var container_height = $(image_container).height(); 
                container_height = container_height - (container_height % line_height) + line_height;
                $(image_container).height( (container_height).toString() + "px" ); 
            }

            return {

                // resize book images down for better print resolution
                shrink_to_print_size: function() {
                    $(this).height( Math.floor($(this).height() * 0.75) );
                },
              
                // line up images along grid and in bounds
                // (used on print)
                align_image: function(line_height, page_height) {
                    pad_image_bottom(this, line_height); 
                    
                    if (is_out_of_bounds(this, page_height)) { 
                        move_to_next(this, page_height); 
                    }
                },

                // grow image container height to align with line height grid
                // (used on web)
                align_container: function(line_height) {
                    align_container(this, line_height); 
                }

            };
        })();
