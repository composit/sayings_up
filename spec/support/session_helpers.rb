module SessionHelpers
  def sign_in_with_abilities( controller, abilities )
    ability = Object.new.extend CanCan::Ability
    abilities.each do |ability_type, ability_object|
      ability.can ability_type, ability_object
    end
    controller.stub( :current_ability ) { ability }
  end

  def signed_in_user_with_abilities( controller, abilities )
    sign_in_with_abilities controller, abilities
    user = mock_model User
    User.stub( :find ).with( user.id ) { user }
    session[:user_id] = user.id
    user
  end
end
