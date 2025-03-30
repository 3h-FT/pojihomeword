class CreatePositiveWords < ActiveRecord::Migration[8.0]
  def change
    create_table :positive_words do |t|
      t.integer :user_id
      t.text :word
      t.boolean :is_custom
      t.integer :situation_id
      t.integer :target_id

      t.timestamps
    end
  end
end
