class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.string :type
      t.integer :category_id
      t.string :param
      t.string :title
      t.string :sub_title
      t.text :short_content
      t.text :content
      t.string :source
      t.string :source_link
      t.integer :author_id
      t.integer :state_id, :default => 1
      t.integer :hits, :default => 0
      t.integer :prime, :default => 0
      t.integer :sticky, :default => 0
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end

