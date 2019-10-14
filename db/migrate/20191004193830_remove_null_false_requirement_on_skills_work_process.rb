class RemoveNullFalseRequirementOnSkillsWorkProcess < ActiveRecord::Migration[6.0]
  def up
    change_column :skills, :work_process_id, :bigint, references: :work_process, null: true, foreign_key: true
  end

  def down
    change_column :skills, :work_process_id, :bigint, references: :work_process, null: false, foreign_key: true
  end
end
