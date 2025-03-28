class Situation < ApplicationRecord
    has_many :positive_words, dependent: :destroy
    validates :name, presence: true
end
