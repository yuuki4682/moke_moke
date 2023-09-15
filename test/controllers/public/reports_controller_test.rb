require "test_helper"

class Public::ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_reports_create_url
    assert_response :success
  end
end
