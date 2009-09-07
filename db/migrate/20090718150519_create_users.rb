class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :type
      t.string :user_name
      t.string :password
      t.string :email
      t.string :validation_code
      t.string :nick_name
      t.integer :gender_id
      t.string :site_url
      t.string :rss_feed
      t.string :avatar_file_name
      t.integer :score, :default => 0
      t.integer :rank, :default => 0
      t.integer :weight, :default => 1
      t.integer :contents_count, :default => 1
      t.datetime :last_login_at
      t.string :last_login_ip
      t.string :created_ip
      t.integer :state_id, :default => 1
      t.timestamps
    end
    add_index :users, :type
    add_index :users, :state_id
  end

  def self.down
    drop_table :users
  end
end

