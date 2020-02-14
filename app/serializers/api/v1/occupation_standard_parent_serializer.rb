class API::V1::OccupationStandardParentSerializer
  include FastJsonapi::ObjectSerializer
  set_type :occupation_standard

  link :self, :url

  attributes :title,
             :industry_title,
             :organization_title,
             :occupation_title,
             :registration_organization_name,
             :registration_state_name
end
