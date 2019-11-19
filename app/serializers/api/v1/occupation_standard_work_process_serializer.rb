class API::V1::OccupationStandardWorkProcessSerializer
  include FastJsonapi::ObjectSerializer
  set_type :work_process

  has_many :skills, links: {
    self: ->(object) { object.relationships_url('skills') },
    related: ->(object) { object.related_url('skills') },
  }

  attribute :title do |object|
    object.work_process.title
  end

  attribute :description do |object|
    object.work_process.description
  end
end
