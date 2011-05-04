class CreateColors < ActiveRecord::Migration
  def self.up
    create_table :colors do |t|
      t.string :name
      t.string :hex
      t.timestamps
    end
    add_column :venues, :color_id, :integer
    add_index :venues, :color_id
  end

  def self.down
    drop_table :colors
    remove_index :venues, :color_id
    remove_column :venues, :color_id
  end
end
