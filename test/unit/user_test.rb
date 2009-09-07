require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_db_column :type
  should_have_db_column :user_name
  should_have_db_column :password
  should_have_db_column :email
  should_have_db_column :validation_code
  should_have_db_column :nick_name
  should_have_db_column :site_url
  should_have_db_column :avatar_image
  should_have_db_column :score
  should_have_db_column :rank
  should_have_db_column :topics_count
  should_have_db_column :last_login_at
  should_have_db_column :last_login_ip
  should_have_db_column :created_ip
end
