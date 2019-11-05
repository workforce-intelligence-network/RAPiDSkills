class API::V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email,
             :name,
             :organization_title
end
