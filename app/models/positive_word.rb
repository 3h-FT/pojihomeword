class PositiveWord < ApplicationRecord
    attr_accessor :target_name, :situation_name
  
    belongs_to :user, optional: true
    belongs_to :situation, optional: true
    belongs_to :target, optional: true
    has_many :word_favorites, dependent: :destroy
  
    validates :situation, presence: true, unless: :is_custom?
    validates :target, presence: true, unless: :is_custom?
  
    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "is_custom", "situation_id", "target_id", "updated_at", "user_id", "word"]
    end
  end
  