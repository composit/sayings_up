class Tagging
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :tag
  belongs_to :user
  belongs_to :exchange

  validates :tag, presence: true
  validates :user_id, presence: true, uniqueness: { scope: [:tag_id, :exchange_id] }
  validates :exchange, presence: true

  attr_accessible :tag_name

  def tag_name
    tag.name if tag
  end

  def tag_name=( name )
    self.tag = Tag.find_or_create_by name: name
  end

  def username
    user.username if user
  end
end
