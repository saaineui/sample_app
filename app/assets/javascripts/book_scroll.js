 /* 
  * BookScroll 
  * ============
  * module for cleanly reflowing and scrolling a book chapter
  * bundled in application.js 
  */
        var BookScroll = (function() {
          
            function update_progress_bar(d) {
                var progress_percent = d.max_clicks > 0 ? Math.floor(d.anchor * d.slice_length / d.max_clicks) : 0;
                progress_percent += d.progress_start;
                progress_percent += "%";
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
          
            function is_top_or_bottom(direction, d) {
                return is_top(direction, d) || is_bottom(direction, d);
            }

            function is_top(direction, d) {
                return direction === "+" && d.anchor === 0;
            }

            function is_bottom(direction, d) {
                return direction === "-" && d.anchor === d.max_clicks;
            }

            return {
                // scroll direction
                get_direction: function(nav_btn){
                    return $(nav_btn).hasClass("up") ? "+" : "-";
                },
              
                // update progress amount and bar width
                update_progress_bar: function(d){
                    update_progress_bar(d);
                },
              
                // update bookmark link params
                update_bookmark_links: function(d){
                    update_bookmark_links(d);
                },
              
                // scroll one page up or down and update bookmark link
                scroll_page: function(direction, d){
                    if (is_top_or_bottom(direction, d)) {
                        return d; // return early if at top or bottom of chapter
                    }

                    // Yes, it's correct that direction/margin and anchor are going in opposite directions
                    d.anchor += direction == "+" ? -1 : 1;

                    // Scroll Page 
                    $("#ebook").animate({ marginTop: direction + "=" + d.scroll_interval + "px" }, 700);

                    update_progress_bar(d);
                    update_bookmark_links(d);
                  
                  return d;
                }
            };
          
        })();
