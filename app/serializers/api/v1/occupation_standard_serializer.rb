class API::V1::OccupationStandardSerializer
  include FastJsonapi::ObjectSerializer
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
end
