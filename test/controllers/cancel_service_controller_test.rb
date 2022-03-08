require 'test_helper'

class CancelServiceControllerTest < ActionDispatch::IntegrationTest
  test "should get cancel" do
    get cancel_service_cancel_url
    assert_response :success
  end

end
