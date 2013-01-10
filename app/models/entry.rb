require 'html_formatting'

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  include HtmlFormatting

  field :user_id, type: Integer
  field :content, type: String

  attr_accessible :content

  embedded_in :exchange, inverse_of: :entries
  embeds_many :comments, cascade_callbacks: true
  belongs_to :user

  validates :user, presence: true

  def exchange_id
    exchange.id if exchange
  end

  def username
    user.username if user
  end
end
