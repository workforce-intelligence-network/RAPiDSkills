class API::V1::StateSerializer
  include FastJsonapi::ObjectSerializer
  attributes :short_name, :long_name

  link :self, :url
end
