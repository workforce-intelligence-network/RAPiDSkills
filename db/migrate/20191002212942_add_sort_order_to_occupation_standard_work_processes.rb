class AddSortOrderToOccupationStandardWorkProcesses < ActiveRecord::Migration[6.0]
  def change
    add_column :occupation_standard_work_processes, :sort_order, :integer, default: 0
  end
end
