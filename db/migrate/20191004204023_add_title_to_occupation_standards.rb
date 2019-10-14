class AddTitleToOccupationStandards < ActiveRecord::Migration[6.0]
  def change
    add_column :occupation_standards, :title, :string
  end
end
