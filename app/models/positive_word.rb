class PositiveWord < ApplicationRecord
  attr_accessor :target_name, :situation_name

  belongs_to :user, optional: true
  belongs_to :situation, optional: true
  belongs_to :target, optional: true
  has_many :word_favorites, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :situation, presence: true, unless: :is_custom?
  validates :target, presence: true, unless: :is_custom?
  validates :word, presence: true, if: -> { is_custom? || persisted? }

  def self.ransackable_attributes(auth_object = nil)
    [ "word" ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w["user"]
  end
end
