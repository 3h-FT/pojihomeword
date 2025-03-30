class Situation < ApplicationRecord
    belongs_to :target
    has_many :positive_words, dependent: :destroy
    validates :name, presence: true
end
