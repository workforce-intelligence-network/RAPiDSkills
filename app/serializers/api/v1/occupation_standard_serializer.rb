class API::V1::OccupationStandardSerializer
  include FastJsonapi::ObjectSerializer
  cache_options enabled: false, cache_length: 1.day

  link :self, :url

  has_many :occupation_standard_work_processes,
    record_type: :work_process,
    key: :work_processes,
    cached: true,
    links: {
      self: ->(object) { object.relationships_url('work_processes') },
      related: ->(object) { object.related_url('occupation_standard_work_processes') },
    }

  has_many :occupation_standard_skills,
    object_method_name: :occupation_standard_skills_with_no_work_process,
    id_method_name: :occupation_standard_skills_with_no_work_process_ids,
    record_type: :skill,
    key: :skills,
    cached: true,
    links: {
      self: ->(object) { object.relationships_url('skills') },
      related: ->(object) { object.related_url('occupation_standard_skills') },
    }

  belongs_to :creator,
    record_type: :user,
    cached: true

  belongs_to :registration_state,
    serializer: API::V1::StateSerializer,
    record_type: :state,
    cached: true,
    links: {
      self: ->(object) { object.relationships_url('registration_state') },
      related: ->(object) { Rails.application.routes.url_helpers.api_v1_state_url(object.registration_state) },
    }, if: Proc.new { |object| object.registration_state }

  belongs_to :occupation,
    cached: true,
    links: {
      self: ->(object) { object.relationships_url('occupation') },
      related: ->(object) { Rails.application.routes.url_helpers.api_v1_occupation_url(object.occupation) },
    }

  belongs_to :organization,
    cached: true,
    links: {
      self: ->(object) { object.relationships_url('organization') },
      related: ->(object) { Rails.application.routes.url_helpers.api_v1_organization_url(object.organization) },
    }

  belongs_to :parent_occupation_standard,
    serializer: API::V1::OccupationStandardParentSerializer,
    record_type: :occupation_standard,
    cached: true,
    links: {
      self: ->(object) { object.relationships_url('parent_occupation_standard') },
      related: ->(object) { Rails.application.routes.url_helpers.api_v1_occupation_standard_url(object.parent_occupation_standard) },
    }, if: Proc.new { |object| object.parent_occupation_standard }

  attributes :hours_count,
             :industry_title,
             :organization_logo_url,
             :organization_title,
             :occupation_kind,
             :occupation_onet_code,
             :occupation_rapids_code,
             :occupation_title,
             :registration_organization_name,
             :registration_state_name,
             :skills_count,
             :title,
             :work_processes_count

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

  attribute :organization_logo_url do |object|
    if object.organization&.logo.attached?
      Rails.application.routes.url_helpers.url_for(object.organization.logo)
    end
  end

  attribute :should_generate_attachments do |object|
    flag = false
    %w(pdf excel).each do |kind|
      flag = true if object.should_generate_attachment?(kind)
    end
    flag
  end
end
