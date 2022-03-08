require 'test_helper'

class CleanersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cleaners_index_url
    assert_response :success
  end

  test "should get new" do
    get cleaners_new_url
    assert_response :success
  end

  test "should get edit" do
    get cleaners_edit_url
    assert_response :success
  end

end
