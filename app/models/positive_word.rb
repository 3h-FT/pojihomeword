class PositiveWord < ApplicationRecord
    attr_accessor :target_name, :situation_name

    belongs_to :user, optional: true
    belongs_to :situation
    belongs_to :target
    has_many :word_favorites, dependent: :destroy

    validates :situation, presence: true
    validates :target, presence: true
end
