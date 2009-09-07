class MiesController < ApplicationController
  allow :exec => :logged_in?, :except => [:send_password, :reset_password]
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = '你的信息已更新.'
        format.html { redirect_to(:action => :show) }
#        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def send_password
    @user = User.find_by_user_name(params[:user_name])
    if simple_captcha_valid? && @user && @user.email == params[:email]
      @user.generate_validation_code if @user.validation_code.blank?
      Emailer.deliver_password_email(@user)
      flash[:notice] = "您的密码已发至邮箱，请查收"
      redirect_to '/'
    else
      flash[:error] = "输入错误，请重新输入"
      redirect_to findback_password_path
    end
  end
  
  # 输入重置密码
  def reset_password
    @user = User.find_by_validation_code(params[:code])
    logged_in!(@user)
    if @user
      @user.generate_validation_code
      flash[:notice] = "请重设您的密码"
      render :action =>:edit
    else
      redirect_to '/'
    end
  end
end
