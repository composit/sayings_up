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

  def as_json( options = {} )
    super( options.merge( only: [:_id, :content, :user_id], include: { comments: { only: [:_id, :content], methods: [:exchange_id, :entry, :entry_user_id, :child_exchange_data] } }, methods: [:exchange_id, :username] ) )
  end

  def exchange_id
    exchange.id if exchange
  end

  def username
    user.username if user
  end
end
