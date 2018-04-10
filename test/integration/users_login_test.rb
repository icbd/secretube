require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "normal login" do
    get login_url
    assert session[:user_id].nil?

    post login_url, params: {
        user: {
            email: @user.email,
            password: "P@ssw0rd"
        }
    }

    assert_redirected_to user_path(@user)
    follow_redirect!

    assert_template 'users/show'
    assert_not session[:user_id].nil?

    delete logout_url

    assert_redirected_to welcome_url
    follow_redirect!

    assert session[:user_id].nil?
  end
end