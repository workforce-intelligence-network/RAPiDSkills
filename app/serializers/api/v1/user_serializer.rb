class API::V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email,
             :name

  belongs_to :employer, serializer: API::V1::OrganizationSerializer, record_type: :organization
end
