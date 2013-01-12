class Tagging
  include Mongoid::Document
  include Mongoid::Timestamps

  field :tag_name

  attr_accessible

  belongs_to :user
  belongs_to :exchange

  validates :user, presence: true
  validates :exchange, presence: true
  validates :tag_name, presence: true
end
