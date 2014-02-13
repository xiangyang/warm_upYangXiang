class UserController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def login
    @user = User.new(:username => params[:user],:password => params[:password])
    respond_to do |format|
      if @user.credentials? == User::ERR_BAD_CREDENTIALS
        msg = { :errCode => User::ERR_BAD_CREDENTIALS}
        format.json { render json:msg}
      else
        logger = User.find_by(username: @user.username)
        logger.count += 1
        logger.save
        msg = { :errCode => User::SUCCESS, :count => logger.count}
        format.json { render json:msg}
      end
    end
  end

  def add
    @user = User.new(:username => params[:user],:password => params[:password])
    respond_to do |format|
      if @user.uniqueUser? == User::ERR_USER_EXISTS
        msg = { :errCode => User::ERR_USER_EXISTS}
        format.json { render json:msg}
      elsif @user.badUser? == User::ERR_BAD_USERNAME
        msg = { :errCode => User::ERR_BAD_USERNAME}
        format.json { render json:msg}
      elsif @user.badPassword? == User::ERR_BAD_PASSWORD
        msg = { :errCode => User::ERR_BAD_PASSWORD}
        format.json { render json:msg}
      else
        @user.count = 1
        @user.save
        msg = { :errCode => User::SUCCESS,:count =>  @user.count}
        format.json { render json:msg}
      end
    end
  end


  def resetFixture
    User.delete_all
    respond_to do |format|
      msg = { :errCode => User::SUCCESS}
      format.json { render json:msg}
    end
  end

  def unitTests
    User.delete_all
    User.new(username: "user1", password: "pass1").save
    responseBox = ""
    failCounter = 0
    #Test1 Username maxsize fail
    user = ""
    pass = "pass2"
    129.times do
      user += "o"
    end
    temp = User.new(username: user, password: pass)
    if temp.badUser? == User::ERR_BAD_USERNAME
      responseBox+="Username fail-maxsize-username test: PASSED\n"
    else
      failcounter+=1
      responseBox+="Username fail-maxsize-username test: FAILED\n"
    end


    #Test2 Username is unique
    user = "user1"
    pass = "pass2"
    temp = User.new(username: user, password: pass)
    if temp.uniqueUser? == User::ERR_USER_EXISTS
      responseBox+="Username fail-unique test: PASSED\n"
    else
      failcounter+=1
      responseBox+="Username fail-unique test: FAILED\n"
    end

    #Test3 Password maxsize fail
    user = "user3"
    pass = ""
    129.times do
      pass += "o"
    end
    temp = User.new(username: user, password: pass)
    if temp.badPassword? == User::ERR_BAD_PASSWORD
      responseBox+="Username fail-maxsize-password test: PASSED\n"
    else
      failCounter+=1
      responseBox+="Username fail-maxsize-password test: FAILED\n"
    end


    #Test4 Empty Password
    user = "user3"
    pass = ""
    temp = User.new(username: user, password: pass)
    if temp.badPassword? == User::ERR_BAD_PASSWORD
      responseBox+="Username fail-empty-password test: PASSED\n"
    else
      failCounter+=1
      responseBox+="Username fail-empty-password test: FAILED\n"
    end

    #Test5 Empty Username
    user = ""
    pass = "pass2"
    temp = User.new(username: user, password: pass)
    if temp.badUser? == User::ERR_BAD_USERNAME
      responseBox+="Username fail-empty-username test: PASSED\n"
    else
      failCounter+=1
      responseBox+="Username fail-empty-username test: FAILED\n"
    end

    #Test6 Matching Credentials Fail
    user = "user1"
    pass = "pass3"
    temp = User.new(username: user, password: pass)
    if temp.credentials? == User::ERR_BAD_CREDENTIALS
      responseBox+="Username fail-credentials test: PASSED\n"
    else
      failcounter+=1
      responseBox+="Username fail-credentials test: FAILED\n"
    end

    #Test7 Passing Username
    user = "user2"
    pass = "pass2"
    temp = User.new(username: user, password: pass)
    if temp.badUser? == User::ERR_BAD_CREDENTIALS
      failcounter+=1
      responseBox+="Username successfull-username test: FAILED\n"
    elsif temp.uniqueUser? == User::ERR_USER_EXISTS
      failcounter+=1
      responseBox+="Username successfull-username test: FAILED\n"
    else
      responseBox+="Username successfull-username test: PASSED\n"
    end

    #Test8 Passing Password
    user = "user2"
    pass = "pass2"
    temp = User.new(username: user, password: pass)
    if temp.badPassword? == User::ERR_BAD_PASSWORD
      failcounter+=1
      responseBox+="Username successfull-username test: FAILED\n"
    else
      responseBox+="Username successfull-credentials test: PASSED\n"
    end

    #Test9 Passing Match Credentials
    user = "user1"
    pass = "pass1"
    temp = User.new(username: user, password: pass)
    if temp.credentials? == User::ERR_BAD_CREDENTIALS
      failcounter+=1
      responseBox+="Username successfull-credentials test: FAILED\n"
    else
      responseBox+="Username successfull-credentials test: PASSED\n"
    end

    #Test10 Multiple Fails
    user = ""
    pass = ""
    temp = User.new(username: user, password: pass)
    if temp.badUser? == User::SUCCESS
      failcounter+=1
      responseBox+="Username fail-multi test: FAILED\n"
    elsif temp.badPassword? == User::SUCCESS
      failcounter+=1
      responseBox+="Username fail-multi test: FAILED\n"
    else
      responseBox+="Username fail-multi test: PASSED\n"
    end
    respond_to do |format|
      msg = { :nrFailed => failCounter, :output => responseBox, :totalTests => 10}
      format.json { render json:msg}
    end
  end
end
