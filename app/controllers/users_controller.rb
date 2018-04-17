class UsersController < ApplicationController
  before_action :must_not_logged_in, only: [:new, :create]
  before_action :must_logged_in, only: [:dashboard]

  def index
    redirect_to signup_url
  end

  def new
    @user = User.new
    render layout: "signup_login"
  end

  def dashboard
    @user = current_user

    @containers = current_user.containers.where("status != #{Container.statuses[:removed]}")

    render "dashboard/main"
  end

  def create
    @user = User.new(user_form_params)
    @user.coin = 3600

    if @user.save
      flash[:success] = "Welcome 🎉"
      log_in @user
      redirect_to dashboard_url
    else
      render :new, layout: "signup_login"
    end
  end


  private

  def user_form_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
