App.cable.subscriptions.create("QuestionsChannel", {
    connected: function() {
    },
    disconnected: function() {
    },
    received: function(data) {
        $('.content-list').append(data);
    }
});