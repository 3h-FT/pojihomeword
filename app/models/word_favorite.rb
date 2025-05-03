class WordFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :positive_word

  validates :user_id, uniqueness: { scope: :positive_word_id }
end
