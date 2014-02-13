class User < ActiveRecord::Base
  SUCCESS = 1
  ERR_BAD_CREDENTIALS = -1
  ERR_USER_EXISTS = -2
  ERR_BAD_USERNAME = -3
  ERR_BAD_PASSWORD = -4
  MAX_USERNAME_LENGTH = 128
  MAX_PASSWORD_LENGTH = 128

  def credentials?(user, pass)
    temp = User.find_by(username: user, password: pass)
    if not temp
      ERR_BAD_CREDENTIALS
    end
    SUCCESS
  end

  def uniqueUser?(user)
    temp = User.find_by(username: user)
    if temp
      ERR_USER_EXISTS
    end
    SUCCESS
  end

  def badUser?(user)
    if String(user).length > MAX_USERNAME_LENGTH || String(user).length == 0
      ERR_BAD_USERNAME
    end
    SUCCESS
  end


  def badPassword?(pass)
    if String(pass).length > MAX_PASSWORD_LENGTH || String(pass).length == 0
      ERR_BAD_PASSWORD
    end
    SUCCESS
  end

  def resetFixture
    User.delete_all
    respond_to do |format|
      msg = { :errCode => User.SUCCESS}
      format.json { render json:msg}
    end
  end

  def unitTests
    end

end
