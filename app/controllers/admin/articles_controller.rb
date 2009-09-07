class Admin::ArticlesController < ApplicationController
  before_filter :init, :only => [:edit, :update]
  layout 'admin'
  deny :exec => "!logged_in?"
  allow :user => :is_admin?, :only => [:destroy, :manage, :update_manage]
  allow :user => :is_author?, :only => [:new, :create]
  allow :only => [:edit, :update], :user => :owns?, :object => :article

  def index
    scope = Article
    scope = scope.with_search(params[:q]) if params[:q].present?
    scope = scope.contributes if params[:contribute].present?
    scope = scope.with_author(current_user) if current_user && !current_user.is_admin?
    @articles = scope.paginate(:include => [:author, :category], :page=>params[:page]||1)

    respond_to do |format|
      format.html
      #      format.xml  { render :xml => @articles }
    end
  end

  def new
    @article = Article.new(:state_id => Content.state_value(:normal))

    respond_to do |format|
      format.html
      #      format.xml  { render :xml => @article }
    end
  end

  def edit
  end

  def create
    @article = Article.new(params[:article])
    @article.author = current_user
    respond_to do |format|
      if @article.save
        flash[:notice] = '文章已成功创建.'
        format.html { redirect_to(admin_articles_path) }
        #        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        #        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = '文章已成功更新.'
        format.html { redirect_to(admin_articles_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        #        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def manage
    @article = Article.find(params[:id])
  end
  
  def update_manage
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = '文章已成功更新.'
        format.html { redirect_to(admin_articles_path) }
        #        format.xml  { head :ok }
      else
        format.html { render :action => "manage" }
        #        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(admin_articles_url) }
      #      format.xml  { head :ok }
    end
  end

  private
  def init
    @article = Article.find(params[:id])
  end
end

