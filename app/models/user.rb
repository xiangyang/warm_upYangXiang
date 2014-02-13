class User < ActiveRecord::Base
  SUCCESS = 1
  ERR_BAD_CREDENTIALS = -1
  ERR_USER_EXISTS = -2
  ERR_BAD_USERNAME = -3
  ERR_BAD_PASSWORD = -4
  MAX_USERNAME_LENGTH = 128
  MAX_PASSWORD_LENGTH = 128

  def credentials?
    temp = User.find_by(username: username, password: password)
    if not temp
      ERR_BAD_CREDENTIALS
    else
      SUCCESS
    end
  end

  def uniqueUser?
    temp = User.find_by(username: username)
    if temp
      ERR_USER_EXISTS
    else
      SUCCESS
    end
  end

  def badUser?
    if username.length > MAX_USERNAME_LENGTH || username.length == 0
      ERR_BAD_USERNAME
    else
      SUCCESS
    end
  end


  def badPassword?
    if password.length > MAX_PASSWORD_LENGTH || password.length == 0
      ERR_BAD_PASSWORD
    else
      SUCCESS
    end
  end


end
