class User < ApplicationRecord
  
  attr_accessor :remember_token

	before_save { email.downcase! }
	validates :name, presence: true
	validates :email, presence: true
	validates :name,  presence: true, length: { maximum: 50 }
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }


  # Returns the hash digest of the given string.(for testing purposes chapter 8)
  def User.digest(string) # Class method
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token # Class method
    SecureRandom.urlsafe_base64
  end

  def remember # Instance method: It creates a token, and stores the digest form of the token into the database
    self.remember_token = User.new_token # using self signifies that remember_token is not a local variable but the instance variable defined by the att_accessor of the class
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
