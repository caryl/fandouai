# == Schema Information
# Schema version: 20090721121407
#
# Table name: users
#
#  id               :integer(4)      not null, primary key
#  type             :string(255)     
#  user_name        :string(255)     
#  password         :string(255)     
#  email            :string(255)     
#  validation_code  :string(255)     
#  nick_name        :string(255)     
#  gender_id        :integer(4)      
#  site_url         :string(255)     
#  rss_feed         :string(255)     
#  avatar_file_name :string(255)     
#  score            :integer(4)      default(0)
#  rank             :integer(4)      default(0)
#  weight           :integer(4)      default(1)
#  contents_count   :integer(4)      
#  last_login_at    :datetime        
#  last_login_ip    :string(255)     
#  created_ip       :string(255)     
#  state_id         :integer(4)      default(1)
#  created_at       :datetime        
#  updated_at       :datetime        
#

class User < ActiveRecord::Base
  acts_as_tagger
  attr_protected :id, :password, :validation_code,  :contents_count,
    :last_login_at, :last_login_ip, :created_at, :created_ip
  attr_accessor :current_password, :new_password, :license, :remember_token

  has_many :articles, :foreign_key => :author_id, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :votings,  :dependent => :destroy
  has_attached_file :avatar, :styles => { :large => '256x256', :middle => "128x128", :small => "32x32" }

  include SimpleState
  has_state :collection => [[:unactived, 0, "未激活"],[:normal, 1, "正常"],[:locked, 2, "已锁定"]]
  
  validates_length_of :user_name, :within => 2..16
  validates_length_of :nick_name, :within => 2..16, :allow_blank => true
  validates_length_of :new_password, :within => 2..16, :allow_blank => true
  validates_confirmation_of :new_password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_uniqueness_of :user_name, :nick_name, :email, :case_sensitive => false
  validates_acceptance_of :license, :accept => "1", :message => '必须被选中才可以注册'
  validates_format_of :site_url, :with => /[a-zA-z]+:\/\/[^\s]*/, :allow_blank => true
  apply_simple_captcha :message => "填写错误"

  default_scope :order => 'contents_count desc'
  
  def name; nick_name; end

  def before_save
    # 如果新密码被设置，则保存之前先加密新密码
    self.password = Encryption.md5(@new_password) unless @new_password.blank?
    self.nick_name ||= self.user_name
  end

  def generate_validation_code
    self.validation_code = Encryption.encrypt(Time.now.to_s + id.to_s)
    save_without_validation
  end
  
  def before_update
    # 更新用户时，不允许更改用户名
    self.user_name = User.find(self).user_name
  end

  def self.authenticate(login, password)
    u = self.find_by_user_name(login)
    u && u.state_is?(:normal) && u.password_match?(password) ? u : nil
  end

  # 验证所给密码是否与自身密码匹配
  def password_match?(current_password)
    self.password == Encryption.md5(current_password)
  end

  # 产生用户校验码
  def generate_validation_code
    self.validation_code = Encryption.encrypt(Time.now.to_s + id.to_s)
    save_without_validation
  end

  #简单的权限控制 base_auth
  def is_admin?
    Conf.admin_users.include? self.user_name
  end

  def is_author?
    is_admin?
  end

  def owns?(entry)
    return true if is_admin?
    entry.respond_to?(:user) && entry.user == self
  end
end
