class UserSession
  def initialize( args )
    @username = args[:username]
    @password = args[:password]
    @user = args[:user]
  end

  def authenticate!
    if user = User.where( username: @username ).first
      @user = user.authenticate @password
    else
      @user = User.create!(username: @username, password: @password)
    end
  end

  def user_id
    @user.id if @user
  end

  def username
    @user.username if @user
  end

  def errors
    { 'username' => ['exists and password does not match'] } unless @user.present?
  end
end
