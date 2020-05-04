$(document).on('turbolinks:load', function(){
    $('section.content').on('click', '.new-comment-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var resourceId = $(this).data('resourceId');
        var resourceType = $(this).data('resourceType');
        $('form#comment-' + resourceType + '-' + resourceId).removeClass('hide');
    });

    $('.comment-form').on ('ajax:success', function(e) {
        $('#flash').html('');
        var [data, status, xhr] = e.detail;

        var commentsList = $('[data-' + data.resource + '-id=' + data.resource_id +'] .comments-list');

        commentsList.append(JST["templates/comment"]({ comment: data }));

        var commentForm = $('form#comment-' + data.resource + '-' + data.resource_id);

        commentForm.find('#comment_body').val('');
        commentForm.addClass('hide');
        commentsList.parent().find('.new-comment-link').show();
    })
    .on ('ajax:error', function(e) {
        $('#flash').html('');

        var [errors, status, xhr] = e.detail;

        $.each(errors.body, function (index, value) {
            $('#flash').append('<p class="alert alert-alert">Comment ' + value +'</p>');
        });
    })
});