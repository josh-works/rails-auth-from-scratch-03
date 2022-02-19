class CreatePointOfInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :point_of_interests do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.text :description

      t.timestamps
    end
  end
end
