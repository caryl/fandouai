# == Schema Information
# Schema version: 20090721121407
#
# Table name: contents
#
#  id             :integer(4)      not null, primary key
#  type           :string(255)     
#  category_id    :integer(4)      
#  param          :string(255)     
#  title          :string(255)     
#  sub_title      :string(255)     
#  short_content  :text            
#  content        :text            
#  source         :string(255)     
#  source_link    :string(255)     
#  author_id      :integer(4)      
#  state_id       :integer(4)      default(1)
#  hits           :integer(4)      default(0)
#  prime          :integer(4)      default(0)
#  sticky         :integer(4)      default(0)
#  comments_count :integer(4)      default(0)
#  created_at     :datetime        
#  updated_at     :datetime        
#

class Content < ActiveRecord::Base
  acts_as_taggable_on :tags
  has_friendly_id :param
  attr_lazy :content
  attr_protected :id, :author_id

  belongs_to :category, :counter_cache => true
  has_many :comments, :as => :commentable, :dependent => :destroy
  belongs_to :author, :class_name => 'User'

  validates_presence_of :param, :title, :short_content, :content
  validates_uniqueness_of :param, :allow_blank => true
  validates_format_of :source_link, :with => /[a-zA-z]+:\/\/[^\s]*/, :allow_blank => true
  
  default_scope :order => 'created_at desc'

  named_scope :with_search, lambda{|keyword| {:conditions => ['contents.title like :key OR contents.short_content like :key', {:key=>"%#{keyword}%"}]}}
  named_scope :with_category, lambda{|category| {:conditions => {:category_id => category}}}
  named_scope :with_tag, lambda{|tag| {:conditions => {:tags => {:id => tag}}, :joins  => :tags}}
  named_scope :with_author, lambda{|author| {:conditions => {:author_id => author}}}
  named_scope :sticky, lambda{{:conditions => ["contents.sticky > 0"], :limit=>5}}
  named_scope :in, lambda{|days|{:conditions => ["contents.created_at > ?", days.days.ago], :limit=>5}}

  include SimpleState
  has_state :collection => [[:draft, 0, "草稿"],[:normal, 1, "正常"],[:list_hidden, 2, "在首页隐藏"],[:locked, 3, "锁定回复"],[:hidden, 4, "隐藏"]]
  named_scope :index,  lambda{{:conditions => {:state_id => [1,3]}}}
  named_scope :visible,  lambda{{:conditions => {:state_id => [1,2,3]}}}

  def self.per_page; 20; end

  def visible?
    [1,2,3].include? self.state_id
  end

  def open_comment?
    [1,2].include?(self.state_id) && (self.comments_count < Conf.max_comments)
  end

  def hit!
    Content.increment_counter(:hits, self.id)
  end

  def set_draft
    self.state_id = Content.state_value(:draft)
    self.sticky = self.prime = self.comments_count = self.hits = 0
  end

  #XXX:fix counter when update
  def after_update
    return unless self.category_id_changed?
    Category.decrement_counter(:contents_count, self.category_id_was)
    Category.increment_counter(:contents_count, self.category_id)
  end

  def  before_validation_on_create
    self.param = "#{Time.now.to_i.to_s(36)}-#{rand(9999999999).to_s(36)}" if param.blank?
    self.sub_title = self.title
  end

  def user; author; end
end

