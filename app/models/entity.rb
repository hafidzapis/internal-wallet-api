class Entity < ApplicationRecord
  has_one :wallet, as: :entity

  validates :type, presence: true

  def as_json(options = {})
    super(only: [:id, :user_name, :name, :created_at, :updated_at])
  end

  def generate_authentication_token
    self.authentication_token = SecureRandom.hex
  end
end