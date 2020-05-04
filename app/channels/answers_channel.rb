class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question#{data['question_id'].to_i}:answers"
  end

  def unfollow
    stop_all_streams
  end
end
