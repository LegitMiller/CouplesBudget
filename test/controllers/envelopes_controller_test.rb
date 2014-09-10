require 'test_helper'

class EnvelopesControllerTest < ActionController::TestCase
  setup do
    @envelope = envelopes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:envelopes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create envelope" do
    assert_difference('Envelope.count') do
      post :create, envelope: { cash: @envelope.cash, color: @envelope.color, icon: @envelope.icon, name: @envelope.name, precent: @envelope.precent, user_id: @envelope.user_id }
    end

    assert_redirected_to envelope_path(assigns(:envelope))
  end

  test "should show envelope" do
    get :show, id: @envelope
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @envelope
    assert_response :success
  end

  test "should update envelope" do
    patch :update, id: @envelope, envelope: { cash: @envelope.cash, color: @envelope.color, icon: @envelope.icon, name: @envelope.name, precent: @envelope.precent, user_id: @envelope.user_id }
    assert_redirected_to envelope_path(assigns(:envelope))
  end

  test "should destroy envelope" do
    assert_difference('Envelope.count', -1) do
      delete :destroy, id: @envelope
    end

    assert_redirected_to envelopes_path
  end
end
