class API::V1::OccupationStandard::Relationships::SkillSerializer
  include FastJsonapi::ObjectSerializer
  set_type :skill
  cache_options enabled: true, cache_length: 1.day
end
