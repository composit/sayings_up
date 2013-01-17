class Tagging
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :tag
  belongs_to :user
  belongs_to :exchange

  validates :tag, presence: true
  validates :user, presence: true
  validates :exchange, presence: true

  def tag_name
    tag.name if tag
  end

  def tag_name=( name )
    self.tag = Tag.find_or_initialize_by name: name
  end
end
