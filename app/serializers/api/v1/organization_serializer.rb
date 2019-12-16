class API::V1::OrganizationSerializer
  include FastJsonapi::ObjectSerializer

  link :self, :url

  attributes :title,
             :logo_url,
             :registers_standards
end
