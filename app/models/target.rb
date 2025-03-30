class Target < ApplicationRecord
    has_many :positive_words, dependent: :destroy
    has_many :situations
    validates :name, presence: true
end
