class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.text :description
      t.integer :usage_count
      t.references :work_process, null: false, foreign_key: true
      t.references :parent_skill, foreign_key: { to_table: :skills }

      t.timestamps
    end
  end
end
