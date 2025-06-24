class RemoveSourceTypeFromPositiveWords < ActiveRecord::Migration[8.0]
  def change
    remove_column :positive_words, :source_type, :integer
  end
end
