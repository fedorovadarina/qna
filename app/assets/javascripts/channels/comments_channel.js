App.cable.subscriptions.create ("CommentsChannel", {
    connected: function() {
        var questionId = $('#question').data('question-id');
        return this.perform('follow', { question_id: questionId });
    },
    disconnected: function() {
        return this.perform('unfollow');
    },
    received: function(data) {
        var commentsList = $('[data-' + data.resource + '-id=' + data.resource_id +'] .comments-list');

        if (data.author.id !== gon.user_id) {
            commentsList.append(JST["templates/comment"]({ comment: data }));
        }
    }
});