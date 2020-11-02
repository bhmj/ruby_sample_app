require 'test_helper'

class HistoryControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get history_new_url
    assert_response :success
  end

end
