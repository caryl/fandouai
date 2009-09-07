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

class  Page < Content
  
end
