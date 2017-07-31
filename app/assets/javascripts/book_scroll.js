 /* 
  * BookScroll 
  * ============
  * module for cleanly reflowing and scrolling a book chapter
  * bundled in application.js 
  */
        var BookScroll = (function() {
          
            var FALLBACK_LINE_HEIGHT = 30;
            var data;
          
            function initialize_data(d) {
                data = Object.assign({}, d);
            }
          
            function update(prop, value) {
                data[prop] = value;
            }
          
            function update_progress_bar() {
                var progress = compute_section_progress() + data.progress_start;
                $("#progress").css("width", progress + "%");
                $("#progress-percent").text( Math.floor(progress) + "%" );
            }
          
            function compute_section_progress() {
                return data.anchor * data.section_progress_points / (data.max_clicks + 1);
            }
          
            function update_bookmark_links() {
                var scroll_param = "scroll=" + compute_scroll(data.anchor, data.max_clicks);

                var bookmark = $("#bookmark").attr("href").replace(/\?scroll=[0-9|.]*/, "")+"?"+scroll_param;
                $("#bookmark").attr("href", bookmark);

                if ($("#new-bookmark").length > 0) {
                    var new_bookmark = $("#new-bookmark").attr("href").replace(/scroll=[0-9|.]*/, scroll_param);
                    $("#new-bookmark").attr("href", new_bookmark);
                }
            }
          
            function update_anchor_and_max_clicks() {
                data.max_clicks = compute_max_clicks(); 
                data.anchor = compute_anchor(); 
            }
          
            function compute_scroll(anchor, max_clicks) {
                return Math.floor(anchor * 100.0 / (max_clicks + 1));
            }
          
            function compute_anchor() {
                if (!is_multipage()) { return 0; } // short pages have no scroll
              
                var estimated_anchor = Math.floor((data.content_height * data.scroll * 0.01) / data.scroll_interval);
                var scroll_diff_one = compute_scroll(estimated_anchor, data.max_clicks) - data.scroll;

                if (scroll_diff_one === 0) { 
                    return estimated_anchor; // exact match found first
                } 
                
                var scroll_diff_two = compute_scroll(estimated_anchor + 1, data.max_clicks) - data.scroll;
              
                if (Math.abs(scroll_diff_one) < Math.abs(scroll_diff_two)) {
                    return estimated_anchor;
                } else {
                    return estimated_anchor + 1;
                }
            }
          
            function compute_max_clicks(){
                if (!is_multipage()) { return 0; } // short pages have no scroll
                                      
                if (data.content_height % data.scroll_interval == 0) { // special handling for full height last page
                    return data.content_height / data.scroll_interval - 1;
                } else { 
                    return Math.floor(data.content_height / data.scroll_interval);
                }
            }

            function is_top_or_bottom(anchor_increment) {
                return is_top(anchor_increment) || is_bottom(anchor_increment);
            }

            function is_top(anchor_increment) {
                return anchor_increment < 0 && data.anchor === 0;
            }

            function is_bottom(anchor_increment) {
                return anchor_increment > 0 && data.anchor === data.max_clicks;
            }
          
            function is_multipage() {
                return data.content_height > data.scroll_interval;
            }

            return {
                // initialize internal data object
                initialize_data: function(d) {
                    initialize_data(d);
                },
              
                // update data property
                update: function(prop, value) {
                    update(prop, value);
                },
              
                // retrieve data object
                data: function() {
                    return data;
                },
              
                // get line height from paragraph or h2 tag; fallback on hard-coded value if none found
                get_line_height: function() {
                    if ($('#ebook h2').length > 0) {
                        return parseInt( $('#ebook h2').css('line-height') ) / 2;
                    }
                    if ($('#ebook p').length > 0) {
                        return parseInt( $('#ebook p').css('line-height') );
                    }
                    return FALLBACK_LINE_HEIGHT;
                },
              
                update_anchor_and_max_clicks: function() {
                    update_anchor_and_max_clicks();
                },
              
                // compute scroll from anchor (for bookmarks)
                compute_scroll: function() {
                    return compute_scroll(data.anchor, data.max_clicks);
                },
                
                // compute anchor (zero index for which page we are on) from scroll
                compute_anchor: function() {
                    return compute_anchor();
                },
              
                // compute upper bound for scroll
                compute_max_clicks: function(){
                    return compute_max_clicks();
                },
              
                // section has overflow
                is_multipage: function() {
                    return is_multipage();
                },
                
                // is a bookmarked link or other prescrolled page
                is_prescrolled_page: function() {
                    return data.anchor > 0;
                },

                // scroll anchor_increment
                get_anchor_increment: function(nav_btn){
                    return $(nav_btn).hasClass("up") ? -1 : 1;
                },
              
                // update progress amount and bar width
                update_progress_bar: function(){
                    update_progress_bar();
                },
              
                // update bookmark link params
                update_bookmark_links: function(){
                    update_bookmark_links();
                },
              
                // scroll one page up or down and update progress bar and bookmark links
                scroll_page: function(anchor_increment){
                    if (is_top_or_bottom(anchor_increment)) {
                        return false; // return early if at top or bottom of chapter
                    }

                    update('anchor', data.anchor + anchor_increment);
                    $("#ebook").animate({ marginTop: -1 * (data.scroll_interval * data.anchor) + "px" }, 700);

                    update_progress_bar();
                    update_bookmark_links();
                }, 
              
                // prescroll page to computed anchor
                prescroll_page: function(){
                    $("#ebook").css("margin-top", -1 * (data.scroll_interval * data.anchor) + "px");
                }
            };
          
        })();
