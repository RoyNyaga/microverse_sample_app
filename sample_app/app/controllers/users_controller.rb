class UsersController < ApplicationController
  def new
  end

  def show
    @user = User.find(params[:id]) # params stands for parameters associated with the request url
  end

end
