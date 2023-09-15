require "test_helper"

class Admin::WorksControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get admin_works_show_url
    assert_response :success
  end
end
