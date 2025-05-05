class AddSourceTypeToPositiveWords < ActiveRecord::Migration[8.0]
  def change
    add_column :positive_words, :source_type, :integer, default: 1
  end
end
