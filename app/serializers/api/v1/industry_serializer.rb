class API::V1::IndustrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :title

  link :self, :url
end
