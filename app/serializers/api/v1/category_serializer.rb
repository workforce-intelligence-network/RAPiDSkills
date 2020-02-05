class API::V1::CategorySerializer
  include FastJsonapi::ObjectSerializer

  link :self, :url

  attributes :name,
             :sort_order
end
