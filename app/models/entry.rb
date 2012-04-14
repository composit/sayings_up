class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: Integer
  field :content, type: String

  attr_accessible :content

  embedded_in :exchange
  embeds_many :comments
  belongs_to :user

  def as_json( options = {} )
    super( options.merge( only: [:_id, :content, :exchange_id], include: :comments, methods: :exchange_id ) )
  end

  def exchange_id
    exchange.id if exchange
  end

=begin
  index :created_at

  after_save :set_exchange_date

  validates :user_id, presence: true
  validates_with AllowsCommentsValidator

  protected
    def set_exchange_date
      exchange.reload
      exchange.update_attributes!( most_recent_entry_date: exchange.entries.all.sort { |x,y| y.created_at <=> x.created_at }[0].created_at )
    end
=end
end
