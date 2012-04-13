class Ability
  include CanCan::Ability

  def initialize( user )
    user ||= User.new # guest user

    can :read, Exchange
    can :create, User
    can :create, Exchange do |exchange|
      exchange.entries.first.user_id == user.id.to_s
    end
    can :update, Exchange do |exchange|
      exchange.ordered_user_ids.include? user.id.to_s
    end
    can :create, Entry do |entry|
      entry.exchange.ordered_user_ids.include?( user.id.to_s )
    end
    can :read, Entry
=begin
    can :read, Entry
    can :create, Entry do |entry|
      EXCHANGE_STARTERS.empty? ? !user.new_record? : EXCHANGE_STARTERS.include?( user.username )
    end
    can :create, Comment
    can :read, Exchange
    can :edit, Exchange do |exchange|
      exchange.users.include?( user )
    end
    can :read, User
=end
  end
end
