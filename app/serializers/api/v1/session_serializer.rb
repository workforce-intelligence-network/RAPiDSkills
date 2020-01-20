class API::V1::SessionSerializer
  include FastJsonapi::ObjectSerializer
  set_type :session

  belongs_to :user,
    links: {
      self: ->(object) { object.relationships_url('user') },
      related: ->(object) { object.related_url('user') },
    }
end
