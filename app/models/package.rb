class Package < ApplicationRecord
  has_many :version, dependent: :destroy
end
