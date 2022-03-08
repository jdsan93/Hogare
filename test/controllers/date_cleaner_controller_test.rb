require 'test_helper'

class DateCleanerControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get date_cleaner_edit_url
    assert_response :success
  end

end
