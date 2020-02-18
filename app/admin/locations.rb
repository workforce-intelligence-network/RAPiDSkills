ActiveAdmin.register Location do
  includes :organization, :state

  permit_params :organization_id, :state_id, :street_address, :city, :zip_code

  preserve_default_filters!
  filter :organization, collection: proc { Organization.order(:title) }
  filter :state, collection: proc { State.order(:long_name) }
end
