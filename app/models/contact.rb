class Contact < ApplicationRecord
  validates :name, presence: true
  validates :content, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
