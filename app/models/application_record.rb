class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def url
    Rails.application.routes.url_helpers.send("api_v1_#{class_name}_url", self)
  end

  def relationships_url(association)
    Rails.application.routes.url_helpers.send("relationships_#{association}_api_v1_#{class_name}_url", self)
  end

  def related_url(association)
    Rails.application.routes.url_helpers.send("api_v1_#{class_name}_#{association}_url", self)
  end

  private

  def class_name
    self.class.base_class.name.underscore
  end
end
