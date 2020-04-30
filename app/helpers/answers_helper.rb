module AnswersHelper
  def link_to_best(answer)
    best_class = "best-answer-icon" if answer.best

    link_to best_answer_path(answer), title: 'Select as best answer',
            method: :patch,
            class: best_class,
            type: "button",
            remote: true,
            'aria-pressed': "false",
            params: {question: @question} do
      octicon 'heart', width: 16
    end
  end
end
