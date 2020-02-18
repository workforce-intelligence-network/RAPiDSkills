ActiveAdmin.register StandardsRegistration do
  includes :occupation_standard, :organization, :state

  permit_params :occupation_standard_id, :organization_id, :state_id

  preserve_default_filters!
  filter :occupation_standard, collection: proc { OccupationStandard.order(:title) }
  filter :organization, collection: proc { Organization.order(:title) }
  filter :state, collection: proc { State.order(:long_name) }
end
