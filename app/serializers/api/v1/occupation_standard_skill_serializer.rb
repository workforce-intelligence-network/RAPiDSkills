class API::V1::OccupationStandardSkillSerializer
  include FastJsonapi::ObjectSerializer
  set_type :skill
  cache_options enabled: true, cache_length: 1.day

  link :self, :url

  attribute :sort_order

  attribute :description do |object|
    object.skill_description
  end
end
