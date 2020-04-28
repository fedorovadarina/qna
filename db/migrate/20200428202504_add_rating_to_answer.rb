class AddRatingToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :rating, :integer, default: 0
  end
end
