module UsersHelper
  def current_user_link
    html =
      if current_user
      content_tag(:span, link_to(current_user.nick_name, my_path), :id=>"current_user_link") \
        << " " << content_tag(:span, link_to('注销', logout_path, :method=>'delete', :confirm => '确定要退出吗?'), :id=>"user_logout_link")
    else
      content_tag(:span, link_to('登录', login_path), :id=>"user_login_link") \
        << " " << content_tag(:span, link_to('注册', signup_path), :id=>"user_signup_link")
    end
    content_tag(:span, html, :class=>'current_user_link')
  end

  def user_link(user, options={})
    user.site_url.present? ? user.site_url : user_path(user, options)
  end
end
