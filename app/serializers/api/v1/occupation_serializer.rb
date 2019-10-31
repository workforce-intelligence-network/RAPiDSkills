class API::V1::OccupationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
             :title,
             :rapids_code,
             :onet_code,
             :term_length_min,
             :term_length_max

  attribute :title_aliases do |object|
    object.title_aliases.join(", ")
  end
end
