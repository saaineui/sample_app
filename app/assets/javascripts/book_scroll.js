 /* 
  * BookScroll 
  * ============
  * module for cleanly reflowing and scrolling a book chapter
  * bundled in application.js 
  */
        var BookScroll = (function() {
          
            function update_progress_bar(d) {
                var progress_percent = Math.floor(d.anchor * d.slice_length / d.max_clicks) + d.progress_start + "%";
                $("#progress").css("width", progress_percent);
                $("#progress-percent").text(progress_percent);
            }
          
            function update_bookmark_links(d) {
                var scroll_param = "scroll=" + Math.floor(d.anchor * 100 / d.max_clicks);

                var bookmark = $("#bookmark").attr("href").replace(/\?scroll=[0-9|.]*/, "")+"?"+scroll_param;
                $("#bookmark").attr("href", bookmark);

                if ($("#new-bookmark").length > 0) {
                    var new_bookmark = $("#new-bookmark").attr("href").replace(/scroll=[0-9|.]*/, scroll_param);
                    $("#new-bookmark").attr("href", new_bookmark);
                }
            }
          
            function is_top_or_bottom(nav_btn, d) {
                return is_top(nav_btn, d) || is_bottom(nav_btn, d);
            }

            function is_top(nav_btn, d) {
                return $(nav_btn).hasClass("up") && d.anchor === 0;
            }

            function is_bottom(nav_btn, d) {
                return $(nav_btn).hasClass("down") && d.anchor === d.max_clicks;
            }

            return {
                // update progress amount and bar width
                update_progress_bar: function(d){
                    update_progress_bar(d);
                },
              
                // update bookmark link params
                update_bookmark_links: function(d){
                    update_bookmark_links(d);
                },
              
                // scroll one page up or down and update bookmark link
                scroll_page: function(d){
                    if (is_top_or_bottom(this, d)) {
                        return d; // return early if at top or bottom of chapter
                    }

                    var direction;

                    // Get scroll direction and increment d.anchor 
                    if ($(this).hasClass("up")) {
                        direction = "+"; d.anchor--; 
                    } else {
                        direction = "-"; d.anchor++; 
                    }

                    // Scroll Page 
                    $("#ebook").animate({ marginTop: direction + "=" + d.scroll_interval + "px" }, 700);

                    update_progress_bar(d);
                    update_bookmark_links(d);
                  
                  return d;
                }
            };
          
        })();
