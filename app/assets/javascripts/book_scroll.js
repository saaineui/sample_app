 /* 
  * BookScroll 
  * ============
  * module for cleanly reflowing and scrolling a book chapter
  * bundled in application.js 
  */
        var BookScroll = (function() {
          
            function update_progress_bar(d) {
                var progress = compute_section_progress(d) + d.progress_start;
                $("#progress").css("width", progress + "%");
                $("#progress-percent").text( Math.floor(progress) + "%" );
            }
          
            function compute_section_progress(d) {
                return d.anchor * d.section_progress_points / (d.max_clicks + 1);
            }
          
            function update_bookmark_links(d) {
                var scroll_param = "scroll=" + compute_scroll(d.anchor, d.max_clicks);

                var bookmark = $("#bookmark").attr("href").replace(/\?scroll=[0-9|.]*/, "")+"?"+scroll_param;
                $("#bookmark").attr("href", bookmark);

                if ($("#new-bookmark").length > 0) {
                    var new_bookmark = $("#new-bookmark").attr("href").replace(/scroll=[0-9|.]*/, scroll_param);
                    $("#new-bookmark").attr("href", new_bookmark);
                }
            }
          
            function compute_scroll(anchor, max_clicks) {
                return Math.floor(anchor * 100.0 / (max_clicks + 1));
            }
          
            function compute_anchor(d) {
                var estimated_anchor = Math.floor((d.content_height * d.scroll * 0.01) / d.scroll_interval);
                var scroll_diff_one = compute_scroll(estimated_anchor, d.max_clicks) - d.scroll;

                if (scroll_diff_one === 0) { 
                    return estimated_anchor; // exact match found first
                } 
                
                var scroll_diff_two = compute_scroll(estimated_anchor + 1, d.max_clicks) - d.scroll;
              
                if (Math.abs(scroll_diff_one) < Math.abs(scroll_diff_two)) {
                    return estimated_anchor;
                } else {
                    return estimated_anchor + 1;
                }
            }
          
            function is_top_or_bottom(anchor_increment, d) {
                return is_top(anchor_increment, d) || is_bottom(anchor_increment, d);
            }

            function is_top(anchor_increment, d) {
                return anchor_increment === -1 && d.anchor === 0;
            }

            function is_bottom(anchor_increment, d) {
                return anchor_increment === 1 && d.anchor === d.max_clicks;
            }

            return {
                // compute anchor (zero index for which page we are on) from scroll
                compute_anchor: function(d) {
                    return compute_anchor(d);
                },
              
                // compute scroll from anchor (for bookmarks)
                compute_scroll: function(d) {
                    return compute_scroll(d.anchor, d.max_clicks);
                },
                
                // compute upper bound for scroll
                compute_max_clicks: function(d){
                    if (d.content_height % d.scroll_interval == 0) { // special handling for full height last page
                        return d.content_height / d.scroll_interval - 1;
                    } else { 
                        return Math.floor(d.content_height / d.scroll_interval);
                    }
                },
              
                // section has overflow
                is_multipage: function(d) {
                    return d.content_height > d.scroll_interval;
                },
                
                // is a bookmarked link or other prescrolled page
                is_prescrolled_page: function(d) {
                    return d.anchor > 0;
                },

                // scroll anchor_increment
                get_anchor_increment: function(nav_btn){
                    return $(nav_btn).hasClass("up") ? -1 : 1;
                },
              
                // update progress amount and bar width
                update_progress_bar: function(d){
                    update_progress_bar(d);
                },
              
                // update bookmark link params
                update_bookmark_links: function(d){
                    update_bookmark_links(d);
                },
              
                // scroll one page up or down and update progress bar and bookmark links
                scroll_page: function(anchor_increment, d){
                    if (is_top_or_bottom(anchor_increment, d)) {
                        return d; // return early if at top or bottom of chapter
                    }

                    d.anchor += anchor_increment;
                    $("#ebook").animate({ marginTop: -1 * (d.scroll_interval * d.anchor) + "px" }, 700);

                    update_progress_bar(d);
                    update_bookmark_links(d);
                  
                    return d;
                }, 
              
                // prescroll page to computed anchor
                prescroll_page: function(d){
                    $("#ebook").css("margin-top", -1 * (d.scroll_interval * d.anchor) + "px");
                }
            };
          
        })();
