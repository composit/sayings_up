class UserSession
  def initialize( args )
    @username = args[:username]
    @password = args[:password]
  end

  def authenticate!
    if user = User.find_by( username: @username )
      @user = user.authenticate @password
    end
  end

  def user_id
    @user.id if @user
  end
end
