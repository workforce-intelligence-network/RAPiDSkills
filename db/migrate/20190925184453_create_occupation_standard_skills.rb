class CreateOccupationStandardSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :occupation_standard_skills do |t|
      t.references :occupation_standard, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
