class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_secure_password

  field :username
  field :password_digest
  field :email

  attr_accessible :username, :email, :password, :password_confirmation

  validates :username, uniqueness: true, presence: true
end
