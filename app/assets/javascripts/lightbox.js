$(document).ready(function() {
    // Lightbox for zooming in on book images
    $("body.books.show #ebook figure img").click(function(){
        $("#lightbox").css("background-image", "url('" + $(this).attr("src") + "')");
        $("#lightbox").show();
    });
  
    $(".close").click(function(){ // also used to close alerts
        $(this).parent().fadeOut(function(){ $(this).hide(); });
    });
});
