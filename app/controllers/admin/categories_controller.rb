class Admin::CategoriesController < ApplicationController
  layout 'admin'
  deny :exec => "!logged_in?"
  allow :user => :is_admin?
  def index
    @categories = Category.find(:all, :order => 'lft')

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @categories }
    end
  end

  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @category }
    end
  end

  def new
    @parent = Category.find_by_id(params[:parent_id])
    @category = Category.new()
    @root = @parent.root if @parent

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @category }
    end
  end

  def edit
    @category = Category.find(params[:id])
    @root = @category.root
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        @category.move_to_child_of(params[:category][:parent_id]) if params[:category][:parent_id].present?
        flash[:notice] = '分类成功创建.'
        format.html { redirect_to(:action => :index) }
#        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        @category.move_to_child_of(params[:category][:parent_id]) if params[:category][:parent_id].present?
        flash[:notice] = '分类信息已更新.'
        format.html { redirect_to(:action => :index) }
#        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(admin_categories_url) }
#      format.xml  { head :ok }
    end
  end
end

