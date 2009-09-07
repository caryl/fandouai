class Admin::UsersController < ApplicationController
  layout "admin"
  deny :exec => "!logged_in?"
  allow :user => :is_admin?
  def index
    @users = User.paginate(:page=>params[:page]||1)

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @users }
    end
  end

  def new
    @user = User.new(:state_id=>User.state_value(:normal))

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    @user.type = params[:type]
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(admin_users_path) }
#        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    @user.type = params[:type]
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(:action => :index) }
#        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
#      format.xml  { head :ok }
    end
  end
end

