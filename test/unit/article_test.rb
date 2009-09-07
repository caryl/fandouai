require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase
  should_have_db_column :type
  should_have_db_column :category_id
  should_have_db_column :param
  should_have_db_column :title
  should_have_db_column :sub_title
  should_have_db_column :short_content
  should_have_db_column :content
  should_have_db_column :show_time
  should_have_db_column :source
  should_have_db_column :source_link
  should_have_db_column :author_id
  should_have_db_column :state_id
  should_have_db_column :sticky_level
  should_have_db_column :comments_count
end
