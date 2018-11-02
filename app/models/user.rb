class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{email.downcase!}
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :subjects, through: :user_subjects

  scope :latest, ->{order(created_at: :desc)}

  validates :name, presence: true,
    length: {maximum: Settings.user.name_max_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.user.email_max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.user.password_min_length},
    allow_nil: true
  VALID_PHONE_NUMBER_REGEX = /\d[0-9]\)*\z/i
  validates :phone_number, presence: true,
    length: {minimum: Settings.user.phone_number_min_length},
    format: {with: VALID_PHONE_NUMBER_REGEX}
  validates :address, presence: true,
    length: {maximum: Settings.user.address_max_length}

  enum role: {trainee: 0, supervisor: 1}

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
