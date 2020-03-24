class API::V1::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email,
             :name,
             :role,
             :settings

  belongs_to :employer,
    serializer: API::V1::OrganizationSerializer,
    record_type: :organization

  has_many :favorites,
    serializer: API::V1::OccupationStandardSerializer,
    record_type: :occupation_standard,
    links: {
      self: ->(object) { object.relationships_url('favorites') },
      related: ->(object) { object.related_url('favorites') },
    }, if: Proc.new { |user| !user.lead? }

  has_many :client_sessions,
    serializer: API::V1::SessionSerializer,
    record_type: :session,
    key: :sessions,
    links: {
      self: ->(object) { object.client_sessions.first.url },
    }, if: Proc.new { |user| user.client_sessions.count.eql?(1) }
end
