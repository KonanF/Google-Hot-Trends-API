require 'test_helper'

class HottrendsControllerTest < ActionController::TestCase
  setup do
    @hottrend = hottrends(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hottrends)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hottrend" do
    assert_difference('Hottrend.count') do
      post :create, :hottrend => @hottrend.attributes
    end

    assert_redirected_to hottrend_path(assigns(:hottrend))
  end

  test "should show hottrend" do
    get :show, :id => @hottrend.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @hottrend.to_param
    assert_response :success
  end

  test "should update hottrend" do
    put :update, :id => @hottrend.to_param, :hottrend => @hottrend.attributes
    assert_redirected_to hottrend_path(assigns(:hottrend))
  end

  test "should destroy hottrend" do
    assert_difference('Hottrend.count', -1) do
      delete :destroy, :id => @hottrend.to_param
    end

    assert_redirected_to hottrends_path
  end
end
