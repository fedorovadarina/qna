$(document).on('turbolinks:load', function(){
    $('.vote-link').on ('ajax:success', function(e) {
        e.preventDefault();
        $('#flash').html('');
        var response = e.detail[0];
        var resourceId = $(this).data(response.resource + 'Id');
        var divRating = $('.vote-rating[data-' + response.resource + '-id=' + resourceId +']');

        if ($(this).hasClass('vote-active')) {
            $(this).removeClass('vote-active');
        } else {
            $(this).closest('.votes').find('a').each(function () {
                $(this).removeClass('vote-active');
            });
            $(this).addClass('vote-active');
        }

        divRating.html(response.rating);
    })
    .on ('ajax:error', function(e) {
        var errors = e.detail[0];

        $.each(errors, function (index, value) {
            $('#flash').append('<p class="alert alert-alert">' + value[0].message +'</p>');
        });
    })
});