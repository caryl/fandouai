class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Emailer.deliver_welcome_email(user)
  end

end