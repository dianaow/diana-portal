$(document).ready(function () {
    $('a.btn-cat-loadmore').click(function (e) {
        e.preventDefault();
        $('.btn-cat-loadmore').hide();
        $('.loading-gif').show();

        var last_id = $('.category').last().attr('data-id');

        $.ajax({

            type: "GET",
            url: $(this).attr('href'),
            data: {
                id: last_id
            },
            dataType: "script",

            success: function () {
                $('.loading-gif').hide();
                $('.btn-cat-loadmore').show();
            }
        });

    });
});