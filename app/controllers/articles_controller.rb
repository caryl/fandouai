class ArticlesController < ApplicationController
  allow :exec => :logged_in?, :only => [:vote]
  
  def index
    scope = Article.visible
    if params[:q]
      @title = "搜索:" + params[:q]
      scope = scope.with_search(params[:q])
    elsif params[:category_id]
      @type = Category.find(params[:category_id])
      @title = "分类:" + @type.try(:name)
      scope = scope.with_category(@type)
    elsif  params[:tag_id]
      @type = Tag.find(params[:tag_id])
      @title = "标签:" + @type.try(:name)
      scope = scope.with_tag(@type)
    elsif params[:author_id]
      @type = Author.find(params[:author_id])
      @title = "作者:" + @type.try(:name)
      scope = scope.with_author(@type)
    end
    @prime_articles = scope.prime.in(90).all(:limit => 10)
    include = [:author, :category, :tags]
    if @title.blank? #首页
      @articles = Article.index.paginate(:include => include, :page=>params[:page]||1)
    else
      @articles = scope.paginate(:include => include, :page=>params[:page]||1)
    end
    
    respond_to do |format|
      format.html
#      format.xml { render :xml => @articles }
      format.rss { render :layout => false}
    end
  end

  def prime
    @title = "推荐"
    @articles = Article.visible.prime.paginate(:include => [:author, :category, :tags], :page=>params[:page]||1)
    render :action => :index
  end
  
  def hot
    @title = "热度"
    @articles = Article.visible.hot.paginate(:include => [:author, :category, :tags], :page=>params[:page]||1)
    render :action => :index
  end

  def vote
    @article = Article.find(params[:id])
    @article.vote_by!(current_user) unless @article.voted_by?(current_user)
    @article.reload
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def show
    scope = Article.visible
    @content = @article = scope.find(params[:id])
    @newer_article = scope.newer_than(@article).first
    @older_article = scope.older_than(@article).first
    @newest_articles = scope.all(:limit => 10)
    @related_articles = @article.find_related_tags(:limit => 10)
    @article.hit!
    respond_to do |format|
      format.html
#      format.xml  { render :xml => @article }
    end
  end

end

