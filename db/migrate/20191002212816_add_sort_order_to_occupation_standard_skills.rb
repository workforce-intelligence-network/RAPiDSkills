class AddSortOrderToOccupationStandardSkills < ActiveRecord::Migration[6.0]
  def change
    add_column :occupation_standard_skills, :sort_order, :integer, default: 0
  end
end
