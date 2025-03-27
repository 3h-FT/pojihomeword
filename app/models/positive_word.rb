class PositiveWord < ApplicationRecord
    belongs_to :user
    belongs_to :situation
    belongs_to :target
end
