class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_secure_password

  field :username
  field :password_digest
  field :email

  #has_many_related :entries
  #has_many_related :comments

  attr_accessible :username, :email, :password, :password_confirmation

  validates :username, :uniqueness => true, :presence => true

=begin
  def exchanges
    Exchange.where( :user_ids => id )
  end
=end
end
