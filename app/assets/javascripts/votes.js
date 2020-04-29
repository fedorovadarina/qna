$(document).on('turbolinks:load', function(){
    $('.vote-link').on ('ajax:success', function(e) {
        e.preventDefault();
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
});