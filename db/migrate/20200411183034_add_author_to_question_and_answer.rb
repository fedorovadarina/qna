class AddAuthorToQuestionAndAnswer < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :author, foreign_key: { to_table: :users }
    change_column_null :questions, :author_id, false

    add_reference :answers, :author, foreign_key: { to_table: :users }
    change_column_null :answers, :author_id, false
  end
end
