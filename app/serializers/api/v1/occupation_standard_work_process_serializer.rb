class API::V1::OccupationStandardWorkProcessSerializer
  include FastJsonapi::ObjectSerializer
  set_type :work_process

  has_many :skills, links: {
    self: ->(object) { 
      Rails.application.routes.url_helpers.relationships_skills_api_v1_work_process_url(object)
    },
    related: ->(object) {
      Rails.application.routes.url_helpers.api_v1_work_process_skills_url(object)
    }
  }

  attribute :title do |object|
    object.work_process.title
  end

  attribute :description do |object|
    object.work_process.description
  end
end
