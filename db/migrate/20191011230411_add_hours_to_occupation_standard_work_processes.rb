class AddHoursToOccupationStandardWorkProcesses < ActiveRecord::Migration[6.0]
  def change
    add_column :occupation_standard_work_processes, :hours, :integer
  end
end
