class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    if data['question_id']
      stream_from "question#{data['question_id']}:comments"
    else
      reject
    end
  end

  def unfollow
    stop_all_streams
  end
end