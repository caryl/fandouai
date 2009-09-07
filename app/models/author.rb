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

class Author < User
  default_scope :order => 'users.weight desc, contents_count desc'
  def is_author?
    true
  end
end
