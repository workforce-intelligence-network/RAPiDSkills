class API::V1::OrganizationSerializer
  include FastJsonapi::ObjectSerializer

  link :self, :url

  attributes :title,
             :registers_standards

  attribute :logo_filename do |object|
    object.logo.filename if object.logo.attached?
  end

  attribute :logo_url do |object|
    if object.logo.attached?
      Rails.application.routes.url_helpers.url_for(object.logo)
    end
  end
end
