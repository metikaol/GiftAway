class User < ApplicationRecord
  has_many :posts, dependent: :nullify
  has_many :answers, dependent: :nullify



  has_secure_password

  validates :first_name, :last_name, presence: true
  validates :contact_number, length: {minimum:10, maximum:10}



  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

# The following validation will check that the email is present, unique
# and follows a certain format. To test the format, a regular
# expression is given which is a sort of scripting language
# to look for patterns in text.
# To learn more: https://regexone.com/
validates :email,
presence: true,
uniqueness: true,
format: VALID_EMAIL_REGEX

def full_name
  "#{first_name} #{last_name}".strip
end

before_validation :clean_contact_number

private
def clean_contact_number
  contact_number = self.contact_number.scan(/\d+/).join
  contact_number[0] == "1" ? contact_number[0] = '' : contact_number
  self.contact_number = contact_number
end




end
