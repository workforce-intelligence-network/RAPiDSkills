class AllowOccupationStandardWorkProcessIdToBeNil < ActiveRecord::Migration[6.0]
  def up
    change_column :occupation_standard_skills, :occupation_standard_work_process_id, :integer, limit: 8,  null: true
  end

  def down
    change_column :occupation_standard_skills, :occupation_standard_work_process_id, :integer, limit: 8, null: false
  end
end
