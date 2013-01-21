class ExchangeTag
  attr_reader :tag_name, :current_user_tagging_id, :number_of_taggings

  def initialize( args )
    @tag_name = args[:tag_name]
    @current_user_tagging_id = args[:current_user_tagging_id]
    @number_of_taggings = args[:number_of_taggings]
  end

  def self.find_by_exchange( exchange, current_user = nil )
    exchange.taggings.each_with_object( Hash.new { |hash, key| hash[key] = [] } ) do |tagging, tags|
      tags[tagging.tag_name] << tagging
    end.sort_by do |k, v|
      v.length
    end.reverse.map do |tag_name, taggings|
      if current_user.present?
        current_user_tagging = taggings.find { |tagging| tagging.user_id == current_user.id }
      end
      current_user_tagging_id = current_user_tagging ? current_user_tagging.id : nil
      ExchangeTag.new tag_name: tag_name, current_user_tagging_id: current_user_tagging_id, number_of_taggings: taggings.length
    end
  end
end
