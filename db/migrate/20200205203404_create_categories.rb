class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.references :occupation_standard_work_process, null: false, foreign_key: true
      t.integer :sort_order

      t.timestamps
    end
  end
end
