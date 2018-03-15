class Post < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  has_many :albums, dependent: :destroy
  accepts_nested_attributes_for :albums, allow_destroy: true

  validates :title, presence: true
  validates :body,
  presence: {message: "must be given"},
  length: {minimum:10, maximum:2000}

# Set up geocoder part
  # attr_accessible :address, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?





  before_save :set_title

  def as_json(_opts = {})
   {
     id: id,
     title: title,
     body: body,
     errors: errors,
     album_photos: albums.map do |x|
       {
         url: x.photo.url.absolute_url,
         name: x.photo_file_name,
         id: x.id
       }
     end
   }
 end


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
