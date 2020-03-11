class API::V1::IndustrySerializer
  include FastJsonapi::ObjectSerializer
  cache_options enabled: true, cache_length: 1.day

  attributes :title

  link :self, :url
end
