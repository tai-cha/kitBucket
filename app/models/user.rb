class User < ApplicationRecord
  before_save { self.screen_name = screen_name.downcase }
  validates :screen_name, uniqueness: true, format: { with: /\A[a-z0-9_]{3,10}\z/, message: '3文字以上10文字以下で半角英数字とアンダースコア( _ )が利用可能です' }
  has_secure_password

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                 BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    remember_token = self.new_token
    update_attributes(remember_digest: self.digest(remember_token))
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attributes(remember_digest: nil)
  end

end
