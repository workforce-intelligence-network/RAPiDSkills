class DropClientSessionsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :client_sessions
  end

  def down
    create_table :client_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :identifier

      t.timestamps
    end
  end
end
