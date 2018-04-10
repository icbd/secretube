class SessionsController < ApplicationController
  before_action :must_not_logged_in, except: [:destroy]
  before_action :must_logged_in, only: [:destroy]

  def new
    @user = User.new
    render layout: "signup_login"
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if @user.authenticate(params[:user][:password])
        log_in @user
        redirect_to dashboard_url
        return
      else
        @user.errors.add(:password, t("wrong_password"))
      end
    else
      @user = User.new
      @user.errors.add(:email, t("email_not_found"))
    end

    render :new, layout: "signup_login"
  end

  def destroy
    log_out
    redirect_to welcome_url
  end
end
