class CreateOccupationStandardWorkProcesses < ActiveRecord::Migration[6.0]
  def change
    create_table :occupation_standard_work_processes do |t|
      t.references :occupation_standard, null: false, foreign_key: true, index: { name: "occupation_standard_id_idx" }
      t.references :work_process, null: false, foreign_key: true

      t.timestamps
    end
  end
end
