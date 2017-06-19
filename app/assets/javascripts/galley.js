$(document).ready(function() {
        $( ".page" ).each(function( index ) {
            var copy = $( this ).clone();
            $( this ).after( copy );
        });
}());