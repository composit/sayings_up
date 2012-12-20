class UserSession
  def initialize( args )
    @username = args[:username]
    @password = args[:password]
  end

  def authenticate!
    if user = User.where( username: @username ).first
      @user = user.authenticate @password
    end
  end

  def user_id
    @user.id if @user
  end

  def errors
    { 'username or password' => ['is incorrect'] } if @user.nil?
  end
end
