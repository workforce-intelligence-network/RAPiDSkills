class API::V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email,
             :name
end
