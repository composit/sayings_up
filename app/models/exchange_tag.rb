class ExchangeTag
  attr_reader :tag_name

  def initialize( args )
    @tag_name = args[:tag_name]
  end

  def self.find_by_exchange( exchange )
    exchange.taggings.each_with_object( Hash.new { |hash, key| hash[key] = [] } ) do |tagging, tags|
      tags[tagging.tag_name] << tagging.username
    end.sort_by do |k, v|
      v.length
    end.reverse.map do |tag_name, usernames|
      ExchangeTag.new tag_name: tag_name, usernames: usernames
    end
  end
end
