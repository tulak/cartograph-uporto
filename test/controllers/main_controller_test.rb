require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get map" do
    get :map
    assert_response :success
  end

end
