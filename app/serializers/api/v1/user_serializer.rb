class API::V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email,
             :name,
             :role

  belongs_to :employer,
    serializer: API::V1::OrganizationSerializer,
    record_type: :organization

  has_many :favorites,
    serializer: API::V1::OccupationStandardSerializer,
    record_type: :occupation_standard,
    links: {
      self: ->(object) { object.relationships_url('favorites') },
      related: ->(object) { object.related_url('favorites') },
    }
end
