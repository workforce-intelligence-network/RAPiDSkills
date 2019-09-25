class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :state, null: false, foreign_key: true
      t.string :street_address
      t.string :city
      t.string :zip_code

      t.timestamps
    end
  end
end
