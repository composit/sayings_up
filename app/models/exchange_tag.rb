class ExchangeTag
  attr_reader :tag_name

  def initialize( args )
    @tag_name = args[:tag_name]
    @current_username = args[:current_username]
    @usernames = args[:usernames]
  end

  def owned_by_current_user
    Array( @usernames ).include? @current_username
  end

  def self.find_by_exchange( exchange, current_username )
    exchange.taggings.each_with_object( Hash.new { |hash, key| hash[key] = [] } ) do |tagging, tags|
      tags[tagging.tag_name] << tagging.username
    end.sort_by do |k, v|
      v.length
    end.reverse.map do |tag_name, usernames|
      ExchangeTag.new tag_name: tag_name, usernames: usernames, current_username: current_username
    end
  end
end
