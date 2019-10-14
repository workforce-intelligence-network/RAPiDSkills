class CreateDataImports < ActiveRecord::Migration[6.0]
  def change
    create_table :data_imports do |t|
      t.string :description
      t.integer :kind

      t.timestamps
    end
  end
end
