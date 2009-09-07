require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase
  context 'GET to index' do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :categories
  end

  context 'GET to new' do
    setup do
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_assign_to :category
  end

  context 'POST to create' do
    setup do
      post :create, :category => Factory.attributes_for(:category)
      @category = Category.find(:all).last
    end
    
    should_redirect_to('POST to create'){category_path(@category)}
  end

  context 'GET to show' do
    setup do
      @category = Factory(:category)
      get :show, :id => @category.id
    end
    should_respond_with :success
    should_render_template :show
    should_assign_to :category
  end

  context 'GET to edit' do
    setup do
      @category = Factory(:category)
      get :edit, :id => @category.id
    end
    should_respond_with :success
    should_render_template :edit
    should_assign_to :category
  end

  context 'PUT to update' do
    setup do
      @category = Factory(:category)
      put :update, :id => @category.id, :category => Factory.attributes_for(:category)
    end
    should_redirect_to('PUT to update'){category_path(@category)}
  end

  context 'DELETE to destroy' do
    setup do
      @category = Factory(:category)
      delete :destroy, :id => @category.id
    end
    should_redirect_to('DELETE to destroy'){categories_path}
  end
end
