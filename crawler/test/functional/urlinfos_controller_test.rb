require 'test_helper'

class UrlinfosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:urlinfos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create urlinfo" do
    assert_difference('Urlinfo.count') do
      post :create, :urlinfo => { }
    end

    assert_redirected_to urlinfo_path(assigns(:urlinfo))
  end

  test "should show urlinfo" do
    get :show, :id => urlinfos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => urlinfos(:one).to_param
    assert_response :success
  end

  test "should update urlinfo" do
    put :update, :id => urlinfos(:one).to_param, :urlinfo => { }
    assert_redirected_to urlinfo_path(assigns(:urlinfo))
  end

  test "should destroy urlinfo" do
    assert_difference('Urlinfo.count', -1) do
      delete :destroy, :id => urlinfos(:one).to_param
    end

    assert_redirected_to urlinfos_path
  end
end
