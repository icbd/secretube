require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user_one = users(:one)
    @user_one.password = "P@ssw0rd"
    @user_one.password_confirmation = "P@ssw0rd"
  end

  test "fixture should be valid" do
    assert @user_one.valid?
  end

  test "email should present and unique" do
    @user_one.email = nil
    assert_not @user_one.valid?

    new_user_same_email_with_one = users(:one)
    assert_difference('User.count', 0) do
      new_user_same_email_with_one.save
    end
  end

  test "valid email should be accepted" do
    valid_emails = %w[user@gmail.com user+123@gmail.com U.S.E.R@Gmail.com u_s-er@gmail.co.jp]
    valid_emails.each do |email|
      @user_one.email = email
      assert @user_one.valid?, ">>> #{email} should be valid."
    end
  end

  test "invalid email should not be accepted" do
    invalid_emails = %W[user 123456 user@123456]
    invalid_emails.each do |email|
      @user_one.email = email
      assert_not @user_one.valid?, ">>> #{email} should not be valid."
    end
  end

  test "user email should be downcase before save" do
    up_str = "ABC#{Time.now.to_i}@Gmail.com"
    @user_one.email = up_str
    assert @user_one.valid?

    @user_one.save
    assert(@user_one.email == up_str.downcase)
  end

  test "user password should be present" do
    @user_one.password = @user_one.password_confirmation = nil
    assert_not @user_one.valid?

    @user_one.password = @user_one.password_confirmation = ''
    assert_not @user_one.valid?

    @user_one.password = @user_one.password_confirmation = '     '
    assert_not @user_one.valid?
  end

  test "user password length should <= 72 characters" do
    pswd = "x"*72
    assert @user_one.valid?

    @user_one.password = @user_one.password_confirmation = pswd
    assert @user_one.valid?

    @user_one.password = @user_one.password_confirmation = pswd+"more"
    assert_not @user_one.valid?
  end
end
