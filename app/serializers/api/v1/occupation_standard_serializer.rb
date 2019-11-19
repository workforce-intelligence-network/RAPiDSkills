class API::V1::OccupationStandardSerializer
  include FastJsonapi::ObjectSerializer
  include Rails.application.routes.url_helpers

  link :self, :url

  has_many :occupation_standard_work_processes, record_type: :work_process, key: :work_processes, links: {
    self: ->(object) { Rails.application.routes.url_helpers.relationships_work_processes_api_v1_occupation_standard_url(object)
    },
    related: ->(object) {
      Rails.application.routes.url_helpers.api_v1_occupation_standard_work_processes_url(object)
    }
  }

  has_many :skills, links: {
    self: ->(object) { Rails.application.routes.url_helpers.relationships_skills_api_v1_occupation_standard_url(object)
    },
    related: ->(object) {
      Rails.application.routes.url_helpers.api_v1_occupation_standard_skills_url(object)
    }
  }

  attributes :title,
             :organization_title,
             :occupation_title,
             :industry_title

  attribute :pdf_filename do |object|
    object.pdf.filename if object.pdf.attached?
  end

  attribute :pdf_url do |object|
    if object.pdf.attached?
      Rails.application.routes.url_helpers.url_for(object.pdf)
    end
  end

  attribute :pdf_created_at do |object|
    object.pdf.created_at if object.pdf.attached?
  end

  attribute :excel_filename do |object|
    object.excel.filename if object.excel.attached?
  end

  attribute :excel_url do |object|
    if object.excel.attached?
      Rails.application.routes.url_helpers.url_for(object.excel)
    end
  end

  attribute :excel_created_at do |object|
    object.excel.created_at if object.excel.attached?
  end

  attribute :should_generate_attachments do |object|
    flag = false
    %w(pdf excel).each do |kind|
      flag = true if object.should_generate_attachment?(kind)
    end
    flag
  end
end
