class UserController < ApplicationController
  skip_before_filter :verify_authenticity_token


  def login
    @user = User.new(user_params)
    result = User.credentials?(@user.username, @user.password)
    respond_to do |format|
      if result == User.ERR_BAD_CREDENTIALS
        msg = { :errCode => User.ERR_BAD_CREDENTIALS}
        format.json { render json:msg}
      else
        logger = User.find_by(username: @user.username)
        logger.count += 1
        logger.save
        msg = { :errCode => User.SUCCESS, :count => logger.count}
        format.json { render json:msg}
      end
    end
  end

  def add
    @user = User.new(user_params)
    respond_to do |format|
      if User.uniqueUser?(@user.username) == User.ERR_USER_EXISTS
        msg = { :errCode => User.ERR_USER_EXISTS}
        format.json { render json:msg}
      elsif User.badUser?(@user.username) == User.ERR_BAD_USERNAME
        msg = { :errCode => User.ERR_BAD_USERNAME}
        format.json { render json:msg}
      elsif User.badPassword?(@user.username) == User.ERR_BAD_PASSWORD
        msg = { :errCode => User.ERR_BAD_PASSWORD}
        format.json { render json:msg}
      else
        @user.save
        msg = { :errCode => User.SUCCESS}
        format.json { render json:msg}
      end
    end
  end


end
