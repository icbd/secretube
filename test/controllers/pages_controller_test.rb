require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get welcome" do
    get welcome_url
    assert_response :success
  end

  test "should get helper" do
    get pages_helper_url
    assert_response :success
  end

end
