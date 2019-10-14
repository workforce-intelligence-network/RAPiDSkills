class RemoveHoursFromWorkProcesses < ActiveRecord::Migration[6.0]
  def change

    remove_column :work_processes, :hours, :integer
  end
end
