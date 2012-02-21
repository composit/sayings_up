class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: Integer
  field :content, type: String

  embedded_in :exchange

  def as_json( options = {} )
    super( options.merge( :only => [:_id, :content] ) )
  end

  def user=( user )
    self.user_id = user.id
    @user = user
  end

  def user
    @user ||= User.where( :_id => user_id ).first
  end

=begin
  index :created_at

  belongs_to_related :user
  embeds_many :comments

  embedded_in :exchange, :inverse_of => :entries

  after_save :set_exchange_date

  validates :user_id, :presence => true
  validates_with AllowsCommentsValidator

  protected
    def set_exchange_date
      exchange.reload
      exchange.update_attributes!( :most_recent_entry_date => exchange.entries.all.sort { |x,y| y.created_at <=> x.created_at }[0].created_at )
    end
=end
end
