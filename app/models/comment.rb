# == Schema Information
# Schema version: 20090721121407
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  commentable_type :string(255)     
#  commentable_id   :integer(4)      
#  content          :text            
#  user_id          :integer(4)      
#  visitor_name     :string(255)     
#  visited_ip       :string(255)     
#  vote_for         :integer(4)      default(0)
#  vote_against     :integer(4)      default(0)
#  state_id         :integer(4)      
#  created_at       :datetime        
#  updated_at       :datetime        
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user

   validates_length_of :content, :minimum => 5
  apply_simple_captcha :message => "填写错误"
  
  include SimpleState
  has_state :collection => [[:unapproved, 0, "未审核"],[:normal, 1, "正常"],[:hidden, 2, "隐藏"]]

  named_scope :with_search, lambda{|keyword| {:conditions => ['comments.content like :key', {:key=>"%#{keyword}%"}]}}

  named_scope :visible,  lambda{{:conditions => {:state_id => 1}}}

  def visible?
    self.state_id == 1
  end

  def user_name
    name = self.user ? user.name : "游客#{self.visitor_name}"
    name.strip.present? ? name.strip : "匿名网友"
  end
  
  def set_count
    self.vote_for = 0
    self.vote_against = 0
    self.state_id = 1
  end
end
