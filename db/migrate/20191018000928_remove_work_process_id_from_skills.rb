class RemoveWorkProcessIdFromSkills < ActiveRecord::Migration[6.0]
  def change
    remove_reference :skills, :work_process, null: false, foreign_key: true
  end
end
