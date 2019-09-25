class CreateWorkProcesses < ActiveRecord::Migration[6.0]
  def change
    create_table :work_processes do |t|
      t.string :title
      t.text :description
      t.integer :hours
      t.references :occupation_standard, null: false, foreign_key: true

      t.timestamps
    end
  end
end
