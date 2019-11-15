class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :occupation_standard, null: false, foreign_key: true

      t.timestamps
    end
  end
end
