class AddEmployerIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :employer, foreign_key: { to_table: :organizations }
  end
end
