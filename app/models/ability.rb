class Ability
  include CanCan::Ability

  def initialize( user )
    user ||= User.new # guest user

    can :read, Exchange
    can :create, User
    can :create, Exchange do |exchange|
      exchange.entries[1].user_id == user.id && exchange.parent_entry.user_id == user.id
    end
    can :update, Exchange do |exchange|
      exchange.ordered_user_ids.include? user.id
    end
    can :create, Entry do |entry|
      entry.exchange.ordered_user_ids.include? user.id
    end
    can :read, Entry
    can :create, Comment
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
