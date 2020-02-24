class API::V1::OccupationStandard::Relationships::WorkProcessSerializer
  include FastJsonapi::ObjectSerializer
  set_type :work_process
  cache_options enabled: true, cache_length: 1.day
end
