# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include SimpleCaptcha::ControllerHelpers
  include ExceptionLoggable
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  rescue_from Authorization::PermissionDenied do |e|
    flash[:error] = '当前用户没有权限访问该页面，请登录'
    store_location
    redirect_to login_path
  end
end
