require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create a new user" do

    assert_difference('User.count', +1) {
      post signup_url, params: {
          user: {
              email: "newuser#{Time.now.to_i}@gmail.com",
              password: "secretPassword12345",
              password_confirmation: "secretPassword12345",
          }
      }
    }

    follow_redirect!

    assert_template 'users/show'

  end

end
