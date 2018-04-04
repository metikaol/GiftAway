class Answer < ApplicationRecord
  belongs_to :post
  belongs_to :user

  # attr_accessor :contact
  validates :contact, presence: true

  validates :body, presence: true
end
