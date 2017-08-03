$(document).ready(function() {
    // Toggle menus 
    $("div.nav-wrapper > ul > li").click(function(){
        var show_menu = !$(this).hasClass("open");

        $(this).parent().children().removeClass("open");

        if (show_menu) {
          $(this).addClass("open");
        }
    });
});
