require 'test_helper'

class VersionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get versions_show_url
    assert_response :success
  end

end
