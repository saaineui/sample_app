$(document).ready(function() {
    // Sample selector events
    $("#toggle-samples").click(function(){
      var label = $(this).text();
      
      if (label.substr(0,4) == 'show') {
        $(this).text(label.replace('show', 'hide'));
      } else {
        $(this).text(label.replace('hide', 'show'));
      }
      
      $("#alt-samples").toggle();
    });
  
    $("#alt-samples input[name=sample]").change(function(){
      $('#alt-samples label').removeClass('selected');
      $(this).next().addClass('selected');
      $("#book_sample").val($(this).next().text());
    });
});
