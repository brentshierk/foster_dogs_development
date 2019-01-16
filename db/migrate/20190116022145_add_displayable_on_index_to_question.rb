class AddDisplayableOnIndexToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :displayable, :boolean, default: false

    Question.where(slug: [:size, :experience, :schedule, :activity]).update_all(displayable: true)
  end
end
