$(document).on('turbolinks:load', function(){
    $('.vote-link').on ('ajax:success', function(e) {
        e.preventDefault();
        var response = e.detail[0];
        var resourceId = $(this).data('resourceId');
        $('.vote-rating[data-' + response.resource + '-id=' + resourceId +']').html(response.rating);
    })
});