class API::V1::OccupationStandardSkillSerializer
  include FastJsonapi::ObjectSerializer
  set_type :skill

  attribute :description do |object|
    object.skill_description
  end
end
