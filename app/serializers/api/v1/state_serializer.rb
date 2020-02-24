class API::V1::StateSerializer
  include FastJsonapi::ObjectSerializer
  cache_options enabled: true, cache_length: 1.day

  attributes :short_name, :long_name

  link :self, :url
end
