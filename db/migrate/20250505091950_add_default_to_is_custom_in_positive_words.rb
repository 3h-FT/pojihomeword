class AddDefaultToIsCustomInPositiveWords < ActiveRecord::Migration[8.0]
  def change
    change_column_default :positive_words, :is_custom, from: nil, to: false
  end
end