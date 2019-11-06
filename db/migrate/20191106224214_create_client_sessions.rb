class CreateClientSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :client_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :identifier

      t.timestamps
    end
  end
end
