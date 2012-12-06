class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  attr_accessible :content

  embedded_in :entry
  belongs_to :user

  validates :user, presence: true

  def as_json( options = {} )
    super( options.merge( only: [:_id, :content], methods: [:exchange_id, :entry_id, :entry_user_id, :child_exchange_data, :user_username] ) )
  end

  def exchange_id
    entry && entry.exchange && entry.exchange.id
  end

  def entry_id
    entry.id if entry
  end

  def entry_user_id
    entry.user_id if entry
  end

  def child_exchange_data
    { id: child_exchange.id, entry_count: child_exchange.entries.count } if child_exchange
  end

  def child_exchange
    Exchange.where( parent_comment_id: id ).first
  end

  def user_username
    user.username if user
  end
end
