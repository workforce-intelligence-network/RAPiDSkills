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
    }, if: Proc.new { |user| !user.lead? }

  has_many :clent_sessions,
    serializer: API::V1::SessionSerializer,
    record_type: :session,
    links: {
      self: ->(object) { object.client_sessions.first.url },
      meta: { access_token: ->(object) { object.client_sessions.first.token }, token_type: "Bearer" }
    }
end
