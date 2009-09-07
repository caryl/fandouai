require File.dirname(__FILE__) + '/../test_helper'

class VotingTest < ActiveSupport::TestCase
  should_have_db_column :votable_type
  should_have_db_column :votable_id
  should_have_db_column :user_id
  should_have_db_column :count
end
