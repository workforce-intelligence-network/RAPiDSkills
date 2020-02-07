class API::V1::CategorySerializer
  include FastJsonapi::ObjectSerializer

  link :self, :url

  attributes :name,
             :sort_order

  has_many :occupation_standard_skills,
    record_type: :skill,
    key: :skills,
    links: {
      self: ->(object) { object.relationships_url('skills') },
      related: ->(object) { object.related_url('occupation_standard_skills') },
    }
end
