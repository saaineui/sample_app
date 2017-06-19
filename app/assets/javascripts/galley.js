$(document).ready(function() {
     
        $( ".page" ).each(function( index ) {
            var copy = $( this ).clone();
            $( this ).after( copy );
        });

		setTimeout(function(){
		
			/* Get line height */
			var line_height = parseInt( jQuery("#ebook p").css("line-height") );
			
			/* Resize book images */
			$("#ebook figure, #ebook h2").each(function() {
				box_height = parseInt( $(this).height() ); 
				$(this).height( (box_height - (box_height % line_height) + line_height).toString() + "px" ); 
			});
                    
                }, 300); /* close delay */			

}());