class Admin::PagesController < ApplicationController
  layout "admin"
  deny :exec => "!logged_in?"
  allow :user => :is_admin?
  def index
    @pages = Page.paginate(:include => [:author, :category],:page=>params[:page]||1)

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @pages }
    end
  end

  def new
    @page = Page.new

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @page }
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(params[:page])
    @page.author = current_user
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(:action => :index) }
#        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @page = Page.find(params[:id])
    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(:action => :index) }
#        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(admin_pages_url) }
#      format.xml  { head :ok }
    end
  end
end

