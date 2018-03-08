class Post < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, presence: true, uniqueness:true
  validates :body,
  presence: {message: "must be given"},
  length: {minimum:10, maximum:2000}




  before_save :set_title


  private
  # instance methode
  # this function can be called by instance only
  # p = Product.new ==> p is instance
  def set_title
    self.title.capitalize!
  end

  end
