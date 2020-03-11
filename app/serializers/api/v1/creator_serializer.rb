class API::V1::CreatorSerializer
  include FastJsonapi::ObjectSerializer
  set_type :user
  cache_options enabled: true, cache_length: 1.day
end
