class UsersController < ApplicationController
  def index
    redirect_to signup_url
  end

  def new
    @user = User.new
    render layout: "signup_login"
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_form_params)

    if @user.save
      flash[:success] = "Welcome 🎉"
      log_in @user
      redirect_to @user
    else
      render :new, layout: "signup_login"
    end
  end


  private

  def user_form_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
