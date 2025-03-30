class PositiveWord < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :situation
    belongs_to :target
end
