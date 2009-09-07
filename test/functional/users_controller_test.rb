require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'GET to index' do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :users
  end

  context 'GET to new' do
    setup do
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_assign_to :user
  end

  context 'POST to create' do
    setup do
      post :create, :user => Factory.attributes_for(:user)
      @user = User.find(:all).last
    end
    
    should_redirect_to('POST to create'){user_path(@user)}
  end

  context 'GET to show' do
    setup do
      @user = Factory(:user)
      get :show, :id => @user.id
    end
    should_respond_with :success
    should_render_template :show
    should_assign_to :user
  end

  context 'GET to edit' do
    setup do
      @user = Factory(:user)
      get :edit, :id => @user.id
    end
    should_respond_with :success
    should_render_template :edit
    should_assign_to :user
  end

  context 'PUT to update' do
    setup do
      @user = Factory(:user)
      put :update, :id => @user.id, :user => Factory.attributes_for(:user)
    end
    should_redirect_to('PUT to update'){user_path(@user)}
  end

  context 'DELETE to destroy' do
    setup do
      @user = Factory(:user)
      delete :destroy, :id => @user.id
    end
    should_redirect_to('DELETE to destroy'){users_path}
  end
end
