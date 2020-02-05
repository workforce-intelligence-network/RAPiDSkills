class API::V1::OccupationStandardWorkProcessSerializer
  include FastJsonapi::ObjectSerializer
  set_type :work_process

  link :self, :url

  attribute :hours

  attribute :title do |object|
    object.work_process_title
  end

  attribute :description do |object|
    object.work_process_description
  end

  has_many :occupation_standard_skills,
    record_type: :skill,
    key: :skills,
    links: {
      self: ->(object) { object.relationships_url('skills') },
      related: ->(object) { object.related_url('occupation_standard_skills') },
    }
end
