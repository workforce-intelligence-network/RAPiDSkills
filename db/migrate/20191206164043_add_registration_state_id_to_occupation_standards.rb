class AddRegistrationStateIdToOccupationStandards < ActiveRecord::Migration[6.0]
  def change
    add_reference :occupation_standards, :registration_state, index: true, foreign_key: { to_table: :states }
  end
end
