App.cable.subscriptions.create ("AnswersChannel", {
    connected: function() {
        var questionId = $('#question').data('question-id');
        return this.perform('follow', { question_id: questionId });
    },
    disconnected: function() {
        return this.perform('unfollow');
    },
    received: function(data) {
        if (data.author.id !== gon.user_id) {
            $('.answers-list').append(JST["templates/answer"]({
                answer: data.answer,
                author: data.author,
                links: data.links,
                files: data.files }));
        }
    }
});