class UserSession
  def initialize(args)
    @username = args[:username]
    @password = args[:password]
    @user = args[:user]
    @errors = Hash.new { |hash, key| hash[key] = [] }
  end

  def authenticate!
    if user = User.where( username: @username ).first
      unless @user = user.authenticate(@password)
        @errors['username'] << 'exists and password does not match'
      end
    else
      user = User.create(username: @username, password: @password)
      if user.save
        @user = user
      else
        @errors['username or password'] << 'can\'t be blank'
      end
    end
    @user.present?
  end

  def user_id
    @user.id if @user
  end

  def username
    @user.username if @user
  end

  def errors
    @errors
  end
end
