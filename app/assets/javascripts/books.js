(function() {
    var playing = false;
    var direction = "-";
    jQuery(window).keydown(function(){
                    direction = "+";
    });
    jQuery(window).keyup(function(){
                    direction = "-";
    });
    jQuery(window).scroll(function(){
                    if (!playing) {
                          playing = true;
                          jQuery("#ebook").animate({ top: direction + "=82vh" }, 1000, function() {
                                                   playing = false;
                          });
                    }
    });
}());