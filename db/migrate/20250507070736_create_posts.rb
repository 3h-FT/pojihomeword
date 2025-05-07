class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :positive_word, foreign_key: true
      t.text :caption
      t.string :post_word, null: false

      t.timestamps
    end
  end
end
