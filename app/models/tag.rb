class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  has_many :taggings
end
