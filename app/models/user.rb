class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum user_type: [:passenger, :driver]

  before_create :generate_api_key

  validates :api_key, uniqueness: true
  validates :email, presence: true
  validate :phone_format

  private

  def generate_api_key
    return if self.class.exists?(api_key: api_key)

    self.api_key = SecureRandom.hex(20)
  end

  def phone_format
    return unless phone.present?

    unless phone.match?(/\A\d{3}\d{3}\d{4}\z/)
      errors.add(:phone, "must be in the format XXXXXXXXXX")
    end
  end
end
