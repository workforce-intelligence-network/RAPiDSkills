class AddCreatorToDataImports < ActiveRecord::Migration[6.0]
  def change
    add_reference :data_imports, :creator, polymorphic: true, null: false
  end
end
