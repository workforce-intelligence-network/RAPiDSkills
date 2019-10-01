class CreateStandardsRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :standards_registrations do |t|
      t.references :occupation_standard, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.references :state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
