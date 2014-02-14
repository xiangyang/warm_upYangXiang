require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    User.new(username: "user1", password: "pass1").save
  end

  def teardown
    User.delete_all
  end

  #Test1 Username maxsize fail
  test "Username_maxsize fail" do
    user = ""
    pass = "pass2"
    129.times do
      user += "o"
    end
    temp = User.new(username: user, password: pass)
    assert temp.badUser? == User::ERR_BAD_USERNAME, "Username fail-maxsize-username test: FAILED\n"
  end


  #Test2 Username is unique
  test "Username_unique fail" do
    user = "user1"
    pass = "pass2"
    temp = User.new(username: user, password: pass)
    assert temp.uniqueUser? == User::ERR_USER_EXISTS, "Username fail-unique test: FAILED\n"
  end

  #Test3 Password maxsize fail
  test "Username maxsize" do
    user = "user3"
    pass = ""
    129.times do
      pass += "o"
    end
    temp = User.new(username: user, password: pass)
    assert temp.badPassword? == User::ERR_BAD_PASSWORD, "Username fail-maxsize-password test: FAILED\n"
  end


  #Test4 Empty Password
  test "Empty Password" do
    user = "user3"
    pass = ""
    temp = User.new(username: user, password: pass)
    assert temp.badPassword? == User::ERR_BAD_PASSWORD, "Username fail-empty-password test: FAILED\n"

  end

  #Test5 Empty Username
  test "Empty Username" do
    user = ""
    pass = "pass2"
    temp = User.new(username: user, password: pass)
    assert temp.badUser? == User::ERR_BAD_USERNAME, "Username fail-empty-username test: FAILED\n"
  end

  #Test6 Matching Credentials Fail
  test "Credential Fail" do
    user = "user1"
    pass = "pass3"
    temp = User.new(username: user, password: pass)
    assert temp.credentials? == User::ERR_BAD_CREDENTIALS, "Username fail-credentials test: FAILED\n"
  end

  #Test7 Passing Username
  test "valid Username" do
    user = "user2"
    pass = "pass2"
    temp = User.new(username: user, password: pass)
    assert temp.badUser? == User::SUCCESS, "Username successfull-username test: FAILED\n"
    assert temp.uniqueUser? == User::SUCCESS, "Username successfull-username test: FAILED\n"

  end

  #Test8 Passing Password
  test "valid password" do
    user = "user2"
    pass = "pass2"
    temp = User.new(username: user, password: pass)
    assert temp.badPassword? == User::SUCCESS, "Username successfull-username test: FAILED\n"
  end

  #Test9 Passing Match Credentials
  test "valid credentials" do
    user = "user1"
    pass = "pass1"
    temp = User.new(username: user, password: pass)
    assert temp.credentials? == User::SUCCESS, "Username successfull-credentials test: FAILED\n"

  end

  #Test10 Multiple Fails
  test "multi_fail" do
    user = ""
    pass = ""
    temp = User.new(username: user, password: pass)
    assert temp.badUser? == User::ERR_BAD_USERNAME, "Username fail-multi test: FAILED\n"
    assert temp.badPassword? == User::ERR_BAD_PASSWORD, "Username fail-multi test: FAILED\n"
  end

end