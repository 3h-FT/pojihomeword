class Post < ApplicationRecord
  belongs_to :user
  belongs_to :positive_word, optional: true
  has_many :comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy

  validates :post_word, presence: true, length: { maximum: 255 }

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :most_favorited, -> {
    left_joins(:post_favorites)
    .select('posts.*, COUNT(post_favorites.id) AS favorites_count')
    .group('posts.id')
    .order('favorites_count DESC')
  }

  def self.ransackable_attributes(auth_object = nil)
    [ "post_word", "caption" ]
  end

  def self.ransackable_associations(auth_object = nil)
      %w["user", "positive_word"]
  end
end
