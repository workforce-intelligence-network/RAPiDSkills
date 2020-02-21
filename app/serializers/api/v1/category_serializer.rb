class API::V1::CategorySerializer
  include FastJsonapi::ObjectSerializer

  link :self, :url

  attributes :name,
             :sort_order

  belongs_to :occupation_standard_work_process,
    record_type: :work_process,
    key: :work_process

  has_many :occupation_standard_skills,
    record_type: :skill,
    key: :skills,
    links: {
      self: ->(object) { object.relationships_url('skills') },
      related: ->(object) { object.related_url('occupation_standard_skills') },
    }
end
