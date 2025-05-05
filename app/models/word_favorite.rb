class WordFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :positive_word

  validates :user_id, uniqueness: { scope: :positive_word_id }

  def self.ransackable_associations(auth_object = nil)
    %w[positive_word]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id positive_word_id created_at updated_at]
  end
end
