class Post < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, presence: true
  validates :body,
  presence: {message: "must be given"},
  length: {minimum:10, maximum:2000}

# Set up geocoder part
  # attr_accessible :address, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?





  before_save :set_title


  private
  # instance methode
  # this function can be called by instance only
  # p = Product.new ==> p is instance
  def set_title
    self.title.capitalize!
  end

  def self.search(search)
  where("title ILIKE ? OR body ILIKE ?", "%#{search}%", "%#{search}%")
  end

  end
