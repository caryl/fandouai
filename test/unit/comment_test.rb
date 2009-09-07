require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  should_have_db_column :commentable_type
  should_have_db_column :commentable_id
  should_have_db_column :title
  should_have_db_column :content
  should_have_db_column :user_id
  should_have_db_column :visitor_name
  should_have_db_column :visited_ip
  should_have_db_column :vote_for
  should_have_db_column :vote_against
  should_have_db_column :state_id
end
