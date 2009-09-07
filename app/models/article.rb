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

class Article < Content
  apply_simple_captcha :message => "填写错误"
  belongs_to :author, :counter_cache => :contents_count, :class_name => 'User'
  named_scope :prime, lambda{{:order => 'contents.prime desc, contents.created_at desc'}}
  named_scope :hot, lambda{ {:order => 'contents.comments_count desc, contents.created_at desc'}}
  named_scope :contributes, lambda{ {:conditions => {:state_id => Article.state_value(:draft)}}}

  named_scope :newer_than, lambda{|article| {:conditions => ["contents.created_at > ?", article.created_at], :order => 'contents.created_at asc'}}
  named_scope :older_than, lambda{|article| {:conditions => ["contents.created_at < ?", article.created_at], :order => 'contents.created_at desc'}}

  has_many :votings, :dependent => :destroy, :as => 'votable'
  has_many :voters, :through => :votings, :source => :user
  
  def voted_by?(user)
    self.votings.exists?(:user_id => user.id)
  end

  def vote_by!(user)
    Voting.create(:user=>user, :votable => self, :count => user.weight)
    Article.update_counters(self.id, :prime => user.weight)
  end
end
