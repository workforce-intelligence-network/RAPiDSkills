class API::V1::OccupationStandardSkillSerializer
  include FastJsonapi::ObjectSerializer
  set_type :skill

  link :self, :url

  attribute :sort_order

  attribute :description do |object|
    object.skill_description
  end
end
