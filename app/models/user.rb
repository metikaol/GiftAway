class User < ApplicationRecord
  has_many :posts, dependent: :nullify
  has_many :answers, dependent: :nullify



    has_secure_password

    validates :first_name, :last_name, presence: true



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

end
