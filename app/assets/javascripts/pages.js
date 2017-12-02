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
            
            dataType: "script",

            success: function () {
                
                $('.loading-gif').hide();
                $('.btn-cat-loadmore').show();
            }

        });
    });
    