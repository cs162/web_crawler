require 'test_helper'

class UrlSearchesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:url_searches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create url_search" do
    assert_difference('UrlSearch.count') do
      post :create, :url_search => { }
    end

    assert_redirected_to url_search_path(assigns(:url_search))
  end

  test "should show url_search" do
    get :show, :id => url_searches(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => url_searches(:one).to_param
    assert_response :success
  end

  test "should update url_search" do
    put :update, :id => url_searches(:one).to_param, :url_search => { }
    assert_redirected_to url_search_path(assigns(:url_search))
  end

  test "should destroy url_search" do
    assert_difference('UrlSearch.count', -1) do
      delete :destroy, :id => url_searches(:one).to_param
    end

    assert_redirected_to url_searches_path
  end
end
