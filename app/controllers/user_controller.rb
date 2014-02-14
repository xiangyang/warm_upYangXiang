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
    system("RAILS_ENV=development ruby -Itest test/models/user_test.rb > test/models/test_output")
    system("tail -1 test/models/test_output > test/models/out")

    out = File.open("test/models/out")
    value = (out.readlines())[0]

    total_tests = Integer(((value.split(",")[0]).scan(/\d+/))[0])
    failed_tests = Integer(((value.split(",")[2]).scan(/\d+/))[0])

    respond_to do |format|
      msg = {:totalTests => total_tests, :nrFailed => failed_tests, :output => (File.open("test/models/test_output")).read}
      format.json { render json:msg}
    end
  end
end
