class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2, :line ]

  validates :username, presence: true
  has_many :positive_words, dependent: :destroy
  has_many :word_favorites, dependent: :destroy
  has_many :favorited_words, through: :word_favorites, source: :positive_word

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :favorite_posts,  through: :post_favorites,  source: :post

  validates :username, presence: true
  # uidが存在する場合のみ、その一意性をproviderのスコープ内で確認する
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  # ポジティブワードのブックマーク
  def bookmark(positive_word)
    favorited_words << positive_word
  end

  def unbookmark(positive_word)
    favorited_words.destroy(positive_word)
  end

  def bookmark?(positive_word)
    favorited_words.include?(positive_word)
  end

  # 投稿のブックマーク
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

  # ユニークな文字列（UUID）を生成する。
  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
