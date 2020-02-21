class AddCategoryIdToOccupationStandardSkills < ActiveRecord::Migration[6.0]
  def change
    add_reference :occupation_standard_skills, :category, foreign_key: true
  end
end
