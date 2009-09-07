class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @user }
    end
  end

  def new
    @user = User.new(:state_id=>User.state_value(:normal))

    respond_to do |format|
      format.html
#      format.xml  { render :xml => @user }
    end
  end

  def create
    @user = User.new(params[:user])
    @user.state_id = User.state_value(:normal)
    @user.created_ip = @user.last_login_ip = request.remote_ip
    @user.last_login_at = DateTime.now
    
    respond_to do |format|
      if  @user.save_with_captcha
        flash[:notice] = "注册成功,欢迎加入#{Conf.site_name}."
        logged_in!(@user)
        format.html { redirect_to(my_path) }
#        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
#        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end