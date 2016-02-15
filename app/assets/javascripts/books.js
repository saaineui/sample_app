(function() {
    var playing = false;
    jQuery(window).scroll(function(){
                    if (!playing) {
                          playing = true;
                          jQuery("#ebook").animate({ top: "-=80vh" }, 1000, function() {
                                                   playing = false;
                          });
                    }
    });
}());