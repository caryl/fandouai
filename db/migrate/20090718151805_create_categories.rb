class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title
      t.string :param
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :contents_count

      t.timestamps
    end
    add_index :categories, [:parent_id, :lft, :rgt]
  end

  def self.down
    drop_table :categories
  end
end
