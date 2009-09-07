require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  context 'GET to index' do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :articles
  end

  context 'GET to new' do
    setup do
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_assign_to :article
  end

  context 'POST to create' do
    setup do
      post :create, :article => Factory.attributes_for(:article)
      @article = Article.find(:all).last
    end
    
    should_redirect_to('POST to create'){article_path(@article)}
  end

  context 'GET to show' do
    setup do
      @article = Factory(:article)
      get :show, :id => @article.id
    end
    should_respond_with :success
    should_render_template :show
    should_assign_to :article
  end

  context 'GET to edit' do
    setup do
      @article = Factory(:article)
      get :edit, :id => @article.id
    end
    should_respond_with :success
    should_render_template :edit
    should_assign_to :article
  end

  context 'PUT to update' do
    setup do
      @article = Factory(:article)
      put :update, :id => @article.id, :article => Factory.attributes_for(:article)
    end
    should_redirect_to('PUT to update'){article_path(@article)}
  end

  context 'DELETE to destroy' do
    setup do
      @article = Factory(:article)
      delete :destroy, :id => @article.id
    end
    should_redirect_to('DELETE to destroy'){articles_path}
  end
end
