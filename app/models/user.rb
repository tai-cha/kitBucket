class User < ApplicationRecord
  validates :screen_name, uniqueness: true
  has_secure_password
end
