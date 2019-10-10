class RemoveCreatorIdFromDataImports < ActiveRecord::Migration[6.0]
  def change

    remove_column :data_imports, :creator_id, :integer
  end
end
