class Emailer < ActionMailer::Base
  def welcome_email(user)
    recipients user.email
    from "admin@#{Conf.site_domain}"
    subject "欢迎注册#{Conf.site_name}!"
    sent_on Time.now
    body :user => user, :feedback_url => "http://#{Conf.site_domain}/feedback"
  end
  def password_email(user)
    recipients user.email
    from "admin@#{Conf.site_domain}"
    subject "您在#{Conf.site_name}的密码邮件!"
    sent_on Time.now
    body :user => user, :feedback_url => "http://#{Conf.site_domain}/feedback"
  end
end
