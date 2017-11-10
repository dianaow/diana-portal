$(document).ready(function() {
    
    $(".follow").on('click', function(e) {
      e.preventDefault();
      var this_id = $(this).find('.recommended-user').attr('data-id');
      
        $.ajax({
    
            type: "GET",
            url: $(this).attr('href'),
            data: {
                id: this_id
            },

        });
    });
    
});