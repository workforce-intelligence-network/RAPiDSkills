class AddOccupationStandardWorkProccessIdToOccupationStandardSkills < ActiveRecord::Migration[6.0]
  def change
    add_reference :occupation_standard_skills, :occupation_standard_work_process, null: false, foreign_key: true, index: { name: 'occupation_standard_work_process_id_idx' }
  end
end
