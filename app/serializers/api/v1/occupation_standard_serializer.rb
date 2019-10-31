class API::V1::OccupationStandardSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title,
             :organization_title,
             :occupation_title,
             :industry_title
end
