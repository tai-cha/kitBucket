class App < ApplicationRecord
  has_many :version, dependent: :destroy
end
