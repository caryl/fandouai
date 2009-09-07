class ContributesController < ApplicationController
  allow :exec => :logged_in?

  def index
    @articles = current_user.articles.paginate(:include => :category, :page=>params[:page]||1)
  end
  
  def new
    @article = Article.new

    respond_to do |format|
      format.html
      #      format.xml  { render :xml => @article }
    end
  end

  def create
    @article = Article.new(params[:article])
    @article.author = current_user
    #投稿为草稿状态
    @article.set_draft
    respond_to do |format|
      if @article.save_with_captcha
        flash[:notice] = '感谢您的投稿，您的稿件已投递，我们将尽快处理.'
        format.html { redirect_to(contributes_path) }
        #        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "contribute" }
        #        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
    @article = current_user.articles.find(params[:id])
    respond_to do |format|
      if @article.state_is?(:draft) && @article.update_attributes(params[:page])
        @article.set_draft && @article.save
        flash[:notice] = '您的投稿已更新.'
        format.html { redirect_to(contributes_path) }
        #        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        #        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

end

