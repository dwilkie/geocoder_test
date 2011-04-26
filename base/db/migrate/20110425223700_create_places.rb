class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :type, :null => false
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
    add_index :places, :type
  end

  def self.down
    drop_table :places
  end
end
