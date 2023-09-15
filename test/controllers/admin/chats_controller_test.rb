require "test_helper"

class Admin::ChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_chats_index_url
    assert_response :success
  end
end
