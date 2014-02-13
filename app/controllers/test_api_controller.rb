class TestApiController < ApplicationController

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
