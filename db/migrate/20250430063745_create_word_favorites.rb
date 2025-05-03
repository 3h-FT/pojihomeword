class CreateWordFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :word_favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :positive_word, null: false, foreign_key: true

      t.timestamps
    end
    add_index :word_favorites, [ :user_id, :positive_word_id ], unique: true
  end
end
