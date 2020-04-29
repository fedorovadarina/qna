module VotesHelper
  def vote_link(resource, action)
    vote = current_user.votes.where("votable_id = :votable_id AND votable_type = :votable_type", {votable_id: resource.id, votable_type: resource.class.name}).first
    vote_active_class = "vote-active" if (vote&.value == 1 && action == :up) || (vote&.value == -1 && action == :down)

    link_to polymorphic_path(resource, action: "vote_#{action}".to_sym),
            title: "Vote #{action}!",
            class: "vote-link #{vote_active_class}",
            remote: true, method: :post,
            data: { type: :json, "#{resource.class.name}-id": resource.id }
  end
end