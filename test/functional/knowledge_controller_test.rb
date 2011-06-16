require 'test_helper'

class KnowledgeControllerTest < ActionController::TestCase
  test "should get test" do
    get :test
    assert_response :success
  end

  test "should get manage" do
    get :manage
    assert_response :success
  end

end
