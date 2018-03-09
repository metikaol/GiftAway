class Answer < ApplicationRecord
  belongs_to :post
  belongs_to :user

  attr_accessor :contact

  validates :body, presence: true
end
