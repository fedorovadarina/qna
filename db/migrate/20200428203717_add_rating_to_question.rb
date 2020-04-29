class AddRatingToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :rating, :integer, default: 0
  end
end
