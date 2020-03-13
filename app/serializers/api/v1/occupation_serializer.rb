class API::V1::OccupationSerializer
  include FastJsonapi::ObjectSerializer
  cache_options enabled: true, cache_length: 1.day

  link :self, :url

  attributes :title,
             :rapids_code,
             :onet_code,
             :onet_page_url,
             :term_length_min,
             :term_length_max

  attribute :title_aliases do |object|
    object.title_aliases.join(", ")
  end
end
