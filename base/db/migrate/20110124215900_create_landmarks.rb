class CreateLandmarks < ActiveRecord::Migration
  def self.up
    create_table :landmarks do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end

  def self.down
    drop_table :landmarks
  end
end
