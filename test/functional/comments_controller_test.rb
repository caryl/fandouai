require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
  context 'GET to index' do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :comments
  end

  context 'GET to new' do
    setup do
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_assign_to :comment
  end

  context 'POST to create' do
    setup do
      post :create, :comment => Factory.attributes_for(:comment)
      @comment = Comment.find(:all).last
    end
    
    should_redirect_to('POST to create'){comment_path(@comment)}
  end

  context 'GET to show' do
    setup do
      @comment = Factory(:comment)
      get :show, :id => @comment.id
    end
    should_respond_with :success
    should_render_template :show
    should_assign_to :comment
  end

  context 'GET to edit' do
    setup do
      @comment = Factory(:comment)
      get :edit, :id => @comment.id
    end
    should_respond_with :success
    should_render_template :edit
    should_assign_to :comment
  end

  context 'PUT to update' do
    setup do
      @comment = Factory(:comment)
      put :update, :id => @comment.id, :comment => Factory.attributes_for(:comment)
    end
    should_redirect_to('PUT to update'){comment_path(@comment)}
  end

  context 'DELETE to destroy' do
    setup do
      @comment = Factory(:comment)
      delete :destroy, :id => @comment.id
    end
    should_redirect_to('DELETE to destroy'){comments_path}
  end
end
