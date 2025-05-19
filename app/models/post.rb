class Post < ApplicationRecord
  belongs_to :user
  belongs_to :positive_word, optional: true
  has_many :comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy

  validates :post_word, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    [ "post_word", "caption" ]
  end

  def self.ransackable_associations(auth_object = nil)
      %w["user", "positive_word"]
  end
end
