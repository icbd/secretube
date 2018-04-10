class UsersController < ApplicationController
  def new
    @user = User.new
    render layout: "signup_login"
  end

  def show
    @user = User.find(params[:id])
  end
end
