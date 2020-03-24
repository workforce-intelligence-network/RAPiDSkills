class API::V1::OccupationStandardSkillSearchSerializer
  include FastJsonapi::ObjectSerializer
  set_type :skill

  attribute :description do |object|
    object.skill_description
  end
end
