class Tagging
  include Mongoid::Document
  include Mongoid::Timestamps

  field :tag_name

  attr_accessible

  belongs_to :user
  belongs_to :exchange
end
