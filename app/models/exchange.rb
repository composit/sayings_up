class Exchange
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible

  embeds_many :entries, cascade_callbacks: true
  belongs_to :parent_exchange, class_name: 'Exchange'
  belongs_to :parent_entry, class_name: 'Entry'
  belongs_to :parent_comment, class_name: 'Comment'

  def as_json( options = {} )
    super(
      options.merge(
        only: [:_id, :content],
        methods: :ordered_user_ids,
        include: {
          entries: {
            include: {
              comments: {
                only: [:_id, :content],
                methods: [:exchange_id, :entry_id, :entry_user_id, :child_exchange_data]
              }
            },
            only: [:_id, :content],
            methods: :exchange_id
          }
        }
      )
    )
  end
  
  def ordered_user_ids
    entries.where( :created_at.exists => true ).sort_by do |entry|
      entry.created_at
    end.collect( &:user_id ).uniq[0..1]
  end

  def initial_values=( values )
    self.parent_exchange = Exchange.find values[:parent_exchange_id]
    self.parent_entry = parent_exchange.entries.find values[:parent_entry_id]
    self.parent_comment = parent_entry.comments.find values[:parent_comment_id]
    entry_one = Entry.new( content: parent_comment.content )
    entry_one.user_id = parent_comment.user_id
    entry_two = Entry.new( content: values[:content] )
    entry_two.user_id = values[:user_id]
    self.entries << [entry_one, entry_two]
  end

  def parent_entry
    parent_exchange.entries.find parent_entry_id
  end

  def parent_comment
    parent_entry.comments.find parent_comment_id
  end
=begin
  field :parent_comment_id
  field :parent_entry_id
  field :parent_exchange_id
  field :most_recent_entry_date, type: Time, default: Time.now

  index :user_ids

  embeds_many :entries
  belongs_to_related :parent_exchange, class_name: "Exchange"

  before_validation :set_user_ids

  named_scope :top_level, where: { parent_comment_id: nil, parent_entry_id: nil, parent_exchange_id: nil }

  def users
    @users ||= User.where( :_id.in => user_ids ).to_a
  end

  def entries_attributes=( attributes_array )
    # until mongoid supports accepts_nested_attributes_for fully
    attributes_array.each do |entry_attributes|
      entry = entries.create( entry_attributes )
      entry.save
    end
  end

  def ordered_entries
    entries.sort { |x,y| x.created_at <=> y.created_at }
  end

  protected
    def set_user_ids
      self.user_ids = users.uniq.compact.collect { |user| user.id }
    end
=end
end
