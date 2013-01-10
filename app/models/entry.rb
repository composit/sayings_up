class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

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

  def html_content
    markdowner = Redcarpet::Markdown.new Redcarpet::Render::HTML, autolink: true
    formatted_content = markdowner.render content.to_s
    formatted_content = Redcarpet::Render::SmartyPants.render formatted_content
    Loofah.fragment( formatted_content ).scrub!( :escape ).scrub!( :nofollow ).to_html
  end
end
