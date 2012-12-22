module SessionHelpers
  def sign_in_with_ability( controller, ability_type, ability_object )
    ability = Object.new.extend CanCan::Ability
    ability.can ability_type, ability_object
    controller.stub( :current_ability ) { ability }
  end

  def signed_in_user_with_ability( controller, ability_type, ability_object )
    sign_in_with_ability( controller, ability_type, ability_object )
    user = mock_model User
    User.stub( :find ).with( user.id ) { user }
    session[:user_id] = user.id
    user
  end
end
