class Admin::SystemsController < ApplicationController
  layout 'admin'
  deny :exec => "!logged_in?"
  allow :user => :is_admin?
  
  def show
  end

  def sitemap
  end

  def restart
    `cd #{Rails.root} && touch tmp/restart.txt`
    flash[:notice] = "已重启passenger服务."
    redirect_to :action => :show
  end

  def config
    File.open("#{Rails.root}/config/site_config.yml", 'r') { |file| @config = file.read }
  end
  def update_config
    File.open("#{Rails.root}/config/site_config.yml", 'w') { |file| file.write params[:config]}
    flash[:notice] = '站点设置已更新，请重启服务'
    redirect_to :action => :show
  end

  def css
    File.open("#{Rails.root}/public/stylesheets/screen.css", 'r') { |file| @css = file.read }
  end
  def update_css
    File.open("#{Rails.root}/public/stylesheets/screen.css", 'w') { |file| file.write params[:css]}
    flash[:notice] = '站点css已更新，请刷新查看'
    redirect_to :action => :show
  end

  def rake
    render :text => '密码错' and return if params[:rake] && params[:pass] != Conf.admin_confirm
  end

  def bakup
    dir = "#{Rails.root}/#{Conf.bak_path}"
    @files = Dir["#{dir}*"]
  end

  def download
    dir = "#{Rails.root}/#{Conf.bak_path}"
    send_file dir << params[:file]
  end
end
