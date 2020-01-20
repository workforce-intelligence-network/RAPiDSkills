class CreateClientSessionsTableWithUuid < ActiveRecord::Migration[6.0]
  def change
    create_table :client_sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
