# == Schema Information
# Schema version: 20090721121407
#
# Table name: categories
#
#  id             :integer(4)      not null, primary key
#  title          :string(255)     
#  parent_id      :integer(4)      
#  lft            :integer(4)      
#  rgt            :integer(4)      
#  contents_count :integer(4)      
#  created_at     :datetime        
#  updated_at     :datetime        
#

class Category < ActiveRecord::Base
  acts_as_nested_set
  has_friendly_id :param

  validates_presence_of :title, :param
  validates_uniqueness_of :param, :allow_blank => true

  has_many :contents
  
  def self.named_as(name, options={})
    category = Category.find_by_param(name)
    category ? category.descendants.all(options) : []
  end

  def name; title; end

  def  before_validation_on_create
    self.param = self.title if self.param.blank?
  end
end