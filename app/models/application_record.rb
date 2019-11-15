class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def url
    Rails.application.routes.url_helpers.send("api_v1_#{self.class.base_class.name.underscore}_url", self)
  end
end
