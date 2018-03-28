class Album < ApplicationRecord
  belongs_to :post, inverse_of: :albums
  has_attached_file \
  :photo, styles: {
    thumb: '100x100>',
    square: '200x200>',
    medium: '300x300>'
  },
  convert_options: {
    all: '-interlace Plane'
  },
  default_url: '/images/default_:style_photo.png'

validates_attachment_presence :photo
validates_attachment_file_name :photo, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/]
end
