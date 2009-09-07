class CreateVotings < ActiveRecord::Migration
  def self.up
    create_table :votings do |t|
      t.string :votable_type
      t.integer :votable_id
      t.integer :user_id
      t.integer :count

      t.timestamps
    end
    add_index :votings, [:votable_type, :votable_id, :count]
    add_index :votings, [:votable_type, :votable_id, :user_id]
  end

  def self.down
    drop_table :votings
  end
end
