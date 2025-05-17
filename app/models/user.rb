class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true

  has_many :positive_words, dependent: :destroy
  has_many :word_favorites, dependent: :destroy
  has_many :favorited_words, through: :word_favorites, source: :positive_word

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :favorite_posts,  through: :post_favorites,  source: :post

  def bookmark(positive_word)
    favorited_words << positive_word
  end

  def unbookmark(positive_word)
    favorited_words.destroy(positive_word)
  end

  def bookmark?(positive_word)
    favorited_words.include?(positive_word)
  end

  def post_bookmark(post)
    favorite_posts << post
  end

  def unpost_bookmark(post)
    favorite_posts.destroy(post)
  end

  def post_bookmarked?(post)
    favorite_posts.include?(post)
  end

  def own?(object)
    id == object&.user_id
  end
end
