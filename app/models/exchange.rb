class Exchange
  include Mongoid::Document
  include Mongoid::Timestamps

  field :parent_entry_id
  field :parent_comment_id

  attr_accessible

  embeds_many :entries, cascade_callbacks: true, inverse_of: :exchange
  belongs_to :parent_exchange, class_name: 'Exchange'

  def ordered_user_ids
    ordered_users.collect &:id
  end

  def ordered_usernames
    ordered_users.collect &:username
  end

  def initial_values=( values )
    self.parent_exchange = Exchange.find values[:parent_exchange_id]
    self.parent_entry_id = parent_exchange.entries.find( values[:parent_entry_id] ).id if parent_exchange.entries.find values[:parent_entry_id]
    self.parent_comment_id = parent_entry.comments.find( values[:parent_comment_id] ).id if parent_entry.comments.find values[:parent_comment_id]
    entry_one = Entry.new( content: parent_comment.content )
    entry_one.user_id = parent_comment.user_id
    entry_two = Entry.new( content: values[:content] )
    entry_two.user_id = values[:user_id]
    self.entries << [entry_one, entry_two]
  end

  def parent_entry
    parent_exchange.entries.find parent_entry_id if parent_entry_id
  end

  def parent_comment
    Exchange.find( parent_exchange_id ).entries.find( parent_entry_id ).comments.find parent_comment_id if parent_exchange_id && parent_entry_id && parent_comment_id
  end

  private
    def ordered_users
      @ordered_users ||= entries.where( :created_at.exists => true ).sort_by do |entry|
        entry.created_at
      end.collect( &:user ).compact.uniq[0..1]
    end
end
