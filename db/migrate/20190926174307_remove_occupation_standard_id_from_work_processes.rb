class RemoveOccupationStandardIdFromWorkProcesses < ActiveRecord::Migration[6.0]
  def change
    remove_reference :work_processes, :occupation_standard, null: false, foreign_key: true
  end
end
