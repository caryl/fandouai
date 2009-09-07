class SessionController < ApplicationController
  def new
    return unless request.post?

    if Conf.captcha_on_login && !simple_captcha_valid?
      @error = "验证码填写错误。"
    end

    self.current_user = User.authenticate(params[:user_name], params[:password])
    if @error.blank? && current_user && !current_user.state_is?(:normal)
      @error = "该用户未激活或被锁定，不能登录。"
    end

    if @error.blank? && logged_in?
      remember_token! if params[:remember_token] == "1"
      current_user.last_login_at = DateTime.now
      current_user.last_login_ip = request.remote_ip
      current_user.save
      flash.now[:notice] = "欢迎回来,#{current_user.nick_name}"
      redirect_back_or_default('/')
    else
      flash.now[:error] = @error || "用户名或密码错误。"
    end
  end

  def destroy
    cookies.delete :login_token
    reset_session
    flash[:notice] = "已成功退出."
    redirect_back_or_default('/')
  end

  # 请求找回密码
  def findback_password
  end

end
